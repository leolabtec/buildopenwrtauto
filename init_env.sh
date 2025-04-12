#!/bin/bash

set -e

DOCKER_IMAGE="openwrt-builder"
DOCKERFILE_PATH="./Dockerfile"
WORKDIR="$HOME/openwrt_build"
OUTDIR="$HOME/outbuild"
CONTAINER_NAME="openwrt-docker"

# === 初始化提示 ===
echo "🔧 初始化 OpenWrt Docker 编译环境..."

# === 创建挂载目录 ===
echo "📁 检查挂载目录..."
mkdir -p "$WORKDIR" "$OUTDIR"
echo "🔐 修复权限..."
sudo chown -R 1000:1000 "$WORKDIR" "$OUTDIR"

# === 检查 Docker 是否已安装 ===
if ! command -v docker &>/dev/null; then
  echo "❌ 未检测到 Docker，请先安装 Docker 后再运行此脚本。"
  exit 1
fi

# === 检查镜像是否存在 ===
if ! docker images | grep -q "$DOCKER_IMAGE"; then
  echo "📦 构建 Docker 镜像：$DOCKER_IMAGE..."
  if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ 未找到 Dockerfile 文件，请将其放置于当前目录。"
    exit 1
  fi
  docker build -t "$DOCKER_IMAGE" -f "$DOCKERFILE_PATH" .
else
  echo "✅ Docker 镜像已存在：$DOCKER_IMAGE"
fi

# === 检查容器是否存在 ===
if docker ps -a | grep -q "$CONTAINER_NAME"; then
  echo "⚙️ 已存在名为 $CONTAINER_NAME 的容器，准备移除并重建..."
  docker rm -f "$CONTAINER_NAME"
fi

# === 创建新容器（非 root 用户 dd） ===
echo "🚀 创建编译容器并挂载目录..."
docker run -dit \
  --name "$CONTAINER_NAME" \
  -v "$WORKDIR":/build \
  -v "$OUTDIR":/outbuild \
  -w /build \
  "$DOCKER_IMAGE" \
  bash

echo "✅ Docker 容器已就绪：$CONTAINER_NAME"
echo "📦 编译目录：$WORKDIR"
echo "📤 输出目录：$OUTDIR"
exit 0
