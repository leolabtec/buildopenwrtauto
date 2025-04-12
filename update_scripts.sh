#!/bin/bash

set -e

CACHE_DIR="$HOME/.openwrt_auto_scripts"
mkdir -p "$CACHE_DIR"

# 子脚本名称与对应 GitHub raw 地址
scripts=(
  init_env.sh
  fetch_source.sh
  configure.sh
  compile.sh
  clean.sh
)

urls=(
  "https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/init_env.sh"
  "https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/fetch_source.sh"
  "https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/configure.sh"
  "https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/compile.sh"
  "https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/clean.sh"
)

for i in "${!scripts[@]}"; do
  script_name="${scripts[$i]}"
  url="${urls[$i]}"

  echo "⬇️ 正在拉取 $script_name ..."
  curl -fsSL "$url" -o "$CACHE_DIR/$script_name"
  chmod +x "$CACHE_DIR/$script_name"
  echo "✅ 已更新 $script_name"
done

echo "✨ 所有子脚本已更新到本地缓存：$CACHE_DIR"
