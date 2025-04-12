#!/bin/bash

set -e

WORKDIR="$HOME/openwrt_build"
OUTDIR="$HOME/outbuild"
SRC_DIR="$WORKDIR/openwrt"
BUILD_LOG="$WORKDIR/build.log"
PLUGIN_LIST="$WORKDIR/plugin_list.txt"
CONFIG_SEED="$WORKDIR/.config.seed"
FETCH_SOURCE_SCRIPT="$HOME/.openwrt_auto_scripts/fetch_source.sh"

# === 自动拉取源码（如果缺失） ===
if [ ! -d "$SRC_DIR" ]; then
  echo "⚠️ 检测到源码目录不存在，自动拉取 OpenWrt 稳定版源码..."
  bash "$FETCH_SOURCE_SCRIPT"
fi

cd "$SRC_DIR"

# === 应用配置 ===
if [ -f "$CONFIG_SEED" ]; then
  cp "$CONFIG_SEED" .config
  echo "✅ 已应用架构配置 (.config.seed)"
fi

# === 加载插件列表 ===
if [ -f "$PLUGIN_LIST" ]; then
  while IFS= read -r plugin; do
    [ -n "$plugin" ] && echo "CONFIG_PACKAGE_${plugin}=y" >> .config
  done < "$PLUGIN_LIST"
  echo "✅ 插件配置已写入 .config"
fi

# === 更新 feeds 并安装 ===
echo "🔃 更新 feeds..."
./scripts/feeds update -a && ./scripts/feeds install -a

# === 执行 defconfig ===
make defconfig

# === 编译固件 ===
echo "🔨 开始编译 OpenWrt...（日志将写入 $BUILD_LOG）"
make -j$(nproc) V=s | tee "$BUILD_LOG"
BUILD_STATUS=${PIPESTATUS[0]}

if [ "$BUILD_STATUS" -ne 0 ]; then
  echo "❌ 编译失败，错误日志如下："
  grep -i 'error' "$BUILD_LOG" | tail -n 30 || true
  exit 1
fi

# === 拷贝输出文件 ===
OUTPUT_DIR=$(find bin/targets -type d -name "*" | head -n 1)
echo "📦 拷贝输出文件到 $OUTDIR..."
mkdir -p "$OUTDIR"
cp -r $OUTPUT_DIR/* "$OUTDIR"/

# === 编译成功后保存配置提示 ===
echo ""
echo "🎉 编译成功！"
echo "是否将当前 .config 保存为默认配置？(用于下次复用) [y/N]"
read -t 30 SAVE_CONFIG
SAVE_CONFIG=${SAVE_CONFIG,,}
if [[ "$SAVE_CONFIG" == "y" ]]; then
  cp .config "$CONFIG_SEED"
  echo "✅ 配置已保存至 $CONFIG_SEED"
else
  echo "ℹ️ 未保存配置，可手动修改 plugin_list.txt/.config.seed"
fi

echo "✅ 固件已保存至：$OUTDIR"
echo "🎉 编译完成，Enjoy your OpenWrt!"
exit 0
