FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 安装编译所需依赖
RUN apt update && apt install -y --no-install-recommends \
    build-essential clang flex g++ gawk gcc-multilib g++-multilib \
    gettext git libncurses-dev libssl-dev python3 python3-pip \
    python3-setuptools python3-distutils swig rsync unzip zlib1g-dev \
    file wget time libtool ccache libelf-dev curl ca-certificates \
    && apt clean && rm -rf /var/lib/apt/lists/*

# 启用 ccache（可加速重编译）
ENV CCACHE_DIR=/ccache
ENV PATH="/usr/lib/ccache:$PATH"
RUN mkdir -p /ccache && chmod 777 /ccache

# 创建编译工作目录
WORKDIR /build

# 默认使用非 root 用户（如需 root 请在 ENTRYPOINT 中自行切换）
RUN useradd -m dd
USER dd
