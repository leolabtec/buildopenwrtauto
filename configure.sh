#!/bin/bash

set -e
WORKDIR="$HOME/openwrt_build"
CONFIG_SEED="$WORKDIR/.config.seed"
PLUGIN_LIST="$WORKDIR/plugin_list.txt"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# === 平台架构选择 ===
echo "\n🔧 请选择平台架构（默认 120 秒后自动选择 x86_64）："
echo "  1) x86_64"
echo "  2) aarch64 (ARM 架构)"
echo -n "请输入编号 [1/2]: "
read -t 120 ARCH_CHOICE || ARCH_CHOICE=1
ARCH_CHOICE=${ARCH_CHOICE:-1}

case $ARCH_CHOICE in
  2)
    echo -e "CONFIG_TARGET_aarch64_generic=y\nCONFIG_TARGET_aarch64_generic_Generic=y" > "$CONFIG_SEED"
    ;;
  *)
    echo -e "CONFIG_TARGET_x86_64=y\nCONFIG_TARGET_x86_64_Generic=y" > "$CONFIG_SEED"
    ;;
esac

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
  clean_plugin=$(echo "$plugin" | tr -d '"')
  echo "$clean_plugin" >> "$PLUGIN_LIST"
  
  # === 自动补全 Passwall 相关依赖 ===
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
