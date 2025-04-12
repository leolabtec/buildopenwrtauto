#!/bin/bash

set -e

WORKDIR="$HOME/openwrt_build"
OUTDIR="$HOME/outbuild"
CACHE_DIR="$HOME/.openwrt_auto_scripts"

# 本地缓存子脚本路径
INIT_ENV="$CACHE_DIR/init_env.sh"
FETCH_SOURCE="$CACHE_DIR/fetch_source.sh"
CONFIGURE="$CACHE_DIR/configure.sh"
COMPILE="$CACHE_DIR/compile.sh"
CLEAN="$CACHE_DIR/clean.sh"
UPDATER="$CACHE_DIR/update_scripts.sh"

mkdir -p "$WORKDIR" "$OUTDIR"
sudo chown -R 1000:1000 "$WORKDIR" "$OUTDIR"

while true; do
  clear
  echo "==============================="
  echo " 🛠 OpenWrt 编译系统 主控菜单"
  echo "==============================="
  echo "推荐执行顺序：1 → 2 → 3 → 4"
  echo ""
  echo "  1) 初始化编译环境（Docker 容器）"
  echo "  2) 拉取 OpenWrt 源码（稳定版 / 最新版）"
  echo "  3) 配置架构与插件（图形化）"
  echo "  4) 编译 OpenWrt 固件"
  echo "  5) 清理所有缓存"
  echo "  6) 手动更新子脚本（从 GitHub 拉取最新）"
  echo "  0) 退出"
  echo ""
  read -p "请输入操作编号 [0-6]: " CHOICE

  case "$CHOICE" in
    1)
      bash "$INIT_ENV"
      read -p "按回车继续..." dummy
      ;;
    2)
      bash "$FETCH_SOURCE"
      read -p "按回车继续..." dummy
      ;;
    3)
      bash "$CONFIGURE"
      read -p "按回车继续..." dummy
      ;;
    4)
      bash "$COMPILE"
      read -p "按回车继续..." dummy
      ;;
    5)
      bash "$CLEAN"
      read -p "按回车继续..." dummy
      ;;
    6)
      bash "$UPDATER"
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
