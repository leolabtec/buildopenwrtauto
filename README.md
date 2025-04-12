# OpenWrt AutoBuild System

> 图形化交互 + Docker 构建 + 稳定插件组合，助你一键编译 OpenWrt 固件！

---

## 🚀 项目简介

本项目旨在为开发者与普通用户提供一套 **模块化、图形化、稳定可靠** 的 OpenWrt 编译自动化系统：

- 支持最新版或稳定版源码选择 ✅
- 图形化选择平台架构与插件 ✅
- 自动补全插件依赖，确保编译成功 ✅
- 使用 Docker 环境隔离，跨平台可用 ✅
- 编译结果自动输出至宿主机 ✅

---

## 📦 项目结构

```
buildopenwrtauto/
├── main.sh              # 主控菜单（入口）
├── init_env.sh          # 初始化 Docker 编译环境
├── fetch_source.sh      # 拉取源码
├── configure.sh         # 配置架构 & 插件
├── compile.sh           # 编译固件
├── clean.sh             # 清理环境
├── update_scripts.sh    # 手动更新子脚本
├── Dockerfile           # 官方推荐 Docker 编译环境
```

---

## 📥 快速开始

### 1. 准备环境
```bash
sudo apt update && sudo apt install docker.io curl whiptail -y
```

### 2. 克隆本项目
```bash
git clone https://github.com/你的ID/buildopenwrtauto.git
cd buildopenwrtauto
chmod +x main.sh
```

### 3. 启动主控菜单
```bash
./main.sh
```

---

## 🎛 主控菜单功能一览

- `1` 初始化环境（构建 Docker 镜像并启动容器）
- `2` 拉取源码（支持稳定版 / 最新开发版）
- `3` 图形化配置架构 + 插件（默认稳定组合）
- `4` 编译固件（输出至 ~/outbuild）
- `5` 清理编译缓存 & 容器
- `6` 手动更新子脚本（GitHub 拉取最新）

---

## 🧱 默认配置说明

| 配置项         | 默认值               |
|----------------|----------------------|
| 架构系统       | x86 / x86_64         |
| 目标设备       | Generic x86/64       |
| 插件集成       | passwall + hysteria2 + openclash + wireguard + netdata 等 |
| 插件依赖补全   | 自动处理依赖冲突，确保成功编译 |
| 插件源         | 官方 + Lienol（五星推荐）|

---

## 📁 编译结果位置

所有编译生成的 `.img.gz` / `.combined.img` 等固件文件将保存至：
```
~/outbuild
```

---

## 🔄 更新子脚本

如需拉取最新版功能模块，请执行：
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/leolabtec/buildopenwrtauto/refs/heads/main/main.sh)
```
脚本将保存至 `~/.openwrt_auto_scripts/` 并用于下次执行。
--------
若遇权限问题，请先执行：
```sh
sudo apt install curl whiptail docker.io -y
```
---

## 👤 作者 & 授权

本项目由 [你的 GitHub 名字] 构建并维护，适用于教学、部署、日常编译。

开源协议：MIT License

---

> 📮 欢迎 issue / PR / star 支持本项目发展！

