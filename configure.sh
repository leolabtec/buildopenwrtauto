#!/bin/bash

set -e
WORKDIR="$HOME/openwrt_build"
CONFIG_SEED="$WORKDIR/.config.seed"
PLUGIN_LIST="$WORKDIR/plugin_list.txt"
SRC_DIR="$WORKDIR/openwrt"
FETCH_SOURCE_SCRIPT="$HOME/.openwrt_auto_scripts/fetch_source.sh"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# === 自动拉取源码（如果缺失） ===
if [ ! -d "$SRC_DIR" ]; then
  echo "⚠️ 检测到源码目录不存在，自动拉取 OpenWrt 稳定版源码..."
  bash "$FETCH_SOURCE_SCRIPT"
fi

cd "$SRC_DIR"

# === 架构选择 ===
echo "🔍 正在加载平台架构列表..."
make defconfig > /dev/null 2>&1 || true
TARGETS=$(make info | grep '^Target:' | awk '{print $2}')
DEFAULT_TARGET="x86"

TARGET=$(whiptail --title "平台选择" --menu "选择 Target System" 20 50 10 $(for t in $TARGETS; do echo "$t" ""; done) 3>&1 1>&2 2>&3) || TARGET=$DEFAULT_TARGET

SUBTARGETS=$(make info | grep "^Target: $TARGET" -A10 | grep '^Subtarget:' | awk -F: '{print $2}' | xargs)
DEFAULT_SUBTARGET="x86_64"
SUBTARGET=$(whiptail --title "子平台选择" --menu "选择 Subtarget" 20 50 10 $(for t in $SUBTARGETS; do echo "$t" ""; done) 3>&1 1>&2 2>&3) || SUBTARGET=$DEFAULT_SUBTARGET

PROFILES=$(make info | grep -A50 "^Target: $TARGET/$SUBTARGET" | grep '^Target Profile:' | cut -d: -f2- | xargs)
DEFAULT_PROFILE="Generic"
PROFILE=$(whiptail --title "目标设备" --menu "选择 Target Profile" 20 70 15 $(for p in $PROFILES; do echo "$p" ""; done) 3>&1 1>&2 2>&3) || PROFILE=$DEFAULT_PROFILE

# === 写入 .config.seed ===
{
  echo "CONFIG_TARGET_${TARGET}=y"
  echo "CONFIG_TARGET_${TARGET}_${SUBTARGET}=y"
  echo "CONFIG_TARGET_${TARGET}_${SUBTARGET}_DEVICE_${PROFILE// /_}=y"
} > "$CONFIG_SEED"

# === 插件选择 ===
whiptail --title "插件选择" --checklist "请选择需要编译进固件的插件：" 20 70 12 \
  "luci-app-passwall"   "多协议代理前端"         ON \
  "luci-app-openclash" "Clash 控制面板"         ON \
  "luci-app-wireguard" "WireGuard VPN 管理"    ON \
  "luci-app-mwan3"      "多 WAN 策略管理"       ON \
  "luci-app-udpxy"      "IPTV 转发工具"          ON \
  "luci-app-vnstat"     "网络流量监控"          ON \
  "ip-full"             "增强版 ip 工具集"       ON \
  "resolveip"           "IP 解析工具"           ON \
  "luci-app-ddns-go"    "Go 版动态域名解析"     ON \
  "netdata"             "系统性能监控面板"       ON \
3>&1 1>&2 2>&3 > selected_plugins.txt

echo "# 插件列表（用于 feeds install）" > "$PLUGIN_LIST"

while IFS= read -r plugin; do
  clean_plugin=$(echo "$plugin" | tr -d '\"')
  echo "$clean_plugin" >> "$PLUGIN_LIST"

  # 自动补全 passwall 依赖
  if [[ "$clean_plugin" == "luci-app-passwall" ]]; then
    echo "trojan-go" >> "$PLUGIN_LIST"
    echo "v2ray-core" >> "$PLUGIN_LIST"
    echo "v2ray-geodata" >> "$PLUGIN_LIST"
    echo "hysteria" >> "$PLUGIN_LIST"
    echo "hysteria2" >> "$PLUGIN_LIST"
  fi
done < selected_plugins.txt

rm -f selected_plugins.txt

echo "✅ 插件列表已保存至: $PLUGIN_LIST"
echo "✅ 架构配置已写入: $CONFIG_SEED"
echo "✅ 配置完成，可继续编译。"
exit 0
