#!/bin/bash

set -e

WORKDIR="$HOME/openwrt_build"
SRC_DIR="$WORKDIR/openwrt"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# === 清理旧源码 ===
if [ -d "$SRC_DIR" ]; then
  echo "⚠️ 检测到已有 OpenWrt 源码目录：$SRC_DIR"
  echo "是否删除旧源码并重新拉取？[y/N] (10 秒后自动取消)"
  read -t 10 CHOICE
  CHOICE=${CHOICE,,}  # 转小写
  if [[ "$CHOICE" == "y" ]]; then
    rm -rf "$SRC_DIR"
  else
    echo "🚫 取消拉取，使用现有源码。"
    exit 0
  fi
fi

# === 版本选择 ===
echo "\n请选择要拉取的 OpenWrt 源码版本："
echo "  1) 最新开发版 (master)"
echo "  2) 官方稳定版（默认，60 秒后自动选择）"
echo -n "请输入编号 [1/2]: "
read -t 60 VERSION
VERSION=${VERSION:-2}

# === 获取稳定版 TAG ===
LATEST_TAG=$(git ls-remote --tags https://github.com/openwrt/openwrt.git | \
  grep -Eo 'refs/tags/v[0-9]+\.[0-9]+(\.[0-9]+)?' | sort -V | tail -n1 | awk -F/ '{print $3}')

# === 拉取源码 ===
if [ "$VERSION" = "1" ]; then
  echo "📥 正在拉取最新开发版源码..."
  git clone --depth=1 https://github.com/openwrt/openwrt.git "$SRC_DIR"
else
  echo "📥 正在拉取稳定版源码 [$LATEST_TAG]..."
  git clone --depth=1 --branch "$LATEST_TAG" https://github.com/openwrt/openwrt.git "$SRC_DIR"
fi

echo "✅ OpenWrt 源码已成功拉取至：$SRC_DIR"
exit 0
