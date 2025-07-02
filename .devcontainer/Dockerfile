# ---- ベースイメージ ---------------------------------------------------------
# VARIANT は devcontainers/base のタグ（Ubuntu 22.04 を想定）
ARG VARIANT="ubuntu-22.04"
FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

# ---- 必須ツール -------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    ca-certificates \
    unzip \
    zip \
    jq \
    gnupg \
    lsb-release \
    openssh-client \
    pkg-config \
    libssl-dev \
    software-properties-common \
    fontconfig fonts-noto-cjk \
    && fc-cache -fv \
    && rm -rf /var/lib/apt/lists/*


