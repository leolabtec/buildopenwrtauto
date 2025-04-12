#!/bin/bash

set -e

WORKDIR="$HOME/openwrt_build"
OUTDIR="$HOME/outbuild"
DOCKER_IMAGE="openwrt-builder"
CONTAINER_NAME="openwrt-docker"

# 子脚本占位 URL（运行前请替换）
INIT_ENV_URL="URL1"
FETCH_SOURCE_URL="URL2"
CONFIGURE_URL="URL3"
COMPILE_URL="URL4"
CLEAN_URL="URL5"

# 权限检查
mkdir -p "$WORKDIR" "$OUTDIR"
chown -R 1000:1000 "$WORKDIR" "$OUTDIR"

if [ ! -w "$WORKDIR" ] || [ ! -w "$OUTDIR" ]; then
  echo "❌ 构建目录或输出目录无写权限，请执行："
  echo "   sudo chown -R \$(id -u):\$(id -g) $WORKDIR $OUTDIR"
  exit 1
fi

while true; do
  clear
  echo "==== 🛠 OpenWrt 编译工具 (主控菜单) ===="
  echo ""
  echo "  1) 初始化编译环境（Docker 容器）"
  echo "  2) 拉取 OpenWrt 源码（最新版 / 稳定版）"
  echo "  3) 配置架构与插件（生成 .config）"
  echo "  4) 编译固件（build）"
  echo "  5) 清理缓存"
  echo "  0) 退出"
  echo ""
  read -p "请输入选项编号：" CHOICE

  case "$CHOICE" in
    1)
      curl -fsSL "$INIT_ENV_URL" | bash
      ;;
    2)
      curl -fsSL "$FETCH_SOURCE_URL" | bash
      ;;
    3)
      curl -fsSL "$CONFIGURE_URL" | bash
      ;;
    4)
      curl -fsSL "$COMPILE_URL" | bash
      ;;
    5)
      curl -fsSL "$CLEAN_URL" | bash
      ;;
    0)
      echo "👋 已退出"
      exit 0
      ;;
    *)
      echo "❌ 无效输入，请重新选择"
      sleep 1
      ;;
  esac
done
