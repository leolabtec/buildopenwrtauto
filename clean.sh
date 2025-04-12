#!/bin/bash

set -e

WORKDIR="$HOME/openwrt_build"
OUTDIR="$HOME/outbuild"
CONTAINER_NAME="openwrt-docker"

read -p "⚠️ 是否清理 OpenWrt 所有临时数据（包括源码、配置与输出）？[y/N]: " CONFIRM
CONFIRM=${CONFIRM,,} # 转小写

if [[ "$CONFIRM" != "y" ]]; then
  echo "🚫 已取消清理操作。"
  exit 0
fi

# === 停止并移除容器 ===
if docker ps -a | grep -q "$CONTAINER_NAME"; then
  echo "🧼 正在移除 Docker 编译容器..."
  docker rm -f "$CONTAINER_NAME"
fi

# === 删除所有挂载数据 ===
echo "🗑 删除源码与编译数据..."
rm -rf "$WORKDIR"

# === 清空输出目录 ===
echo "🗑 清空编译输出..."
rm -rf "$OUTDIR"

echo "✅ 清理完成，环境已重置。"
exit 0
