#!/bin/bash

set -e

WORKDIR="$HOME/openwrt_build"
OUTDIR="$HOME/outbuild"
DOCKER_IMAGE="openwrt-builder"
CONTAINER_NAME="openwrt-docker"

# ✅ 子脚本 URL 映射
INIT_ENV_URL="https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/init_env.sh"
FETCH_SOURCE_URL="https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/fetch_source.sh"
CONFIGURE_URL="https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/configure.sh"
COMPILE_URL="https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/compile.sh"
CLEAN_URL="https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/clean.sh"

mkdir -p "$WORKDIR" "$OUTDIR"
sudo chown -R 1000:1000 "$WORKDIR" "$OUTDIR"

while true; do
  clear
  echo "==============================="
  echo " 🛠 OpenWrt 编译系统 主控菜单"
  echo "==============================="
  echo ""
  echo "  1) 初始化编译环境（Docker 容器）"
  echo "  2) 拉取 OpenWrt 源码（稳定版 / 最新版）"
  echo "  3) 配置架构与插件（图形化）"
  echo "  4) 编译 OpenWrt 固件"
  echo "  5) 清理所有缓存"
  echo "  0) 退出"
  echo ""
  read -p "请输入操作编号 [0-5]: " CHOICE

  case "$CHOICE" in
    1)
      curl -fsSL "$INIT_ENV_URL" | bash
      read -p "按回车继续..." dummy
      ;;
    2)
      curl -fsSL "$FETCH_SOURCE_URL" | bash
      read -p "按回车继续..." dummy
      ;;
    3)
      curl -fsSL "$CONFIGURE_URL" | bash
      read -p "按回车继续..." dummy
      ;;
    4)
      curl -fsSL "$COMPILE_URL" | bash
      read -p "按回车继续..." dummy
      ;;
    5)
      curl -fsSL "$CLEAN_URL" | bash
      read -p "按回车继续..." dummy
      ;;
    0)
      echo "👋 再见！"
      exit 0
      ;;
    *)
      echo "❌ 无效输入，请重新选择"
      sleep 1
      ;;
  esac

done
