#!/bin/bash

set -e
CACHE_DIR="$HOME/.openwrt_auto_scripts"
mkdir -p "$CACHE_DIR"
cd "$CACHE_DIR"

# 拉取更新脚本
echo "⬇️ 正在拉取 update_scripts.sh ..."
curl -fsSL -o update_scripts.sh https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/update_scripts.sh
chmod +x update_scripts.sh

# 执行更新脚本
echo "🔄 正在更新所有子脚本..."
bash update_scripts.sh

# 拉取 main.sh 并保存到缓存（✅ FIX：新增）
echo "⬇️ 正在拉取 main.sh ..."
curl -fsSL -o main.sh https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/main.sh
chmod +x main.sh

# ✅ 启动主菜单（使用缓存版本）
echo "🚀 启动主菜单系统..."
bash "$CACHE_DIR/main.sh"
