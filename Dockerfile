# syntax=docker/dockerfile:1.7
# `base` CUDA flavor (~200MB): the CUDA runtime libs (cudart/cublas/cudnn/nvrtc)
# come from pip nvidia-* wheels (the 4.2GB nvidia/ dir in the venv), and the GPU
# driver is injected by the host's nvidia-container-runtime — so the `runtime`
# (~2.5GB) and `devel` (~6GB) flavors are redundant.
# Build with BuildKit:  DOCKER_BUILDKIT=1 docker build .
FROM nvidia/cuda:12.8.0-base-ubuntu22.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
# Isaac Sim's Vulkan/GL rendering needs the `graphics` capability; the nvidia/cuda
# images default to compute,utility only, so request it explicitly here.
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all

# システムパッケージ: ランタイム共有ライブラリ + sdist ビルド用の build-essential
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3.10-dev \
    python3-pip \
    git \
    wget \
    curl \
    ca-certificates \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libosmesa6-dev \
    libglu1-mesa \
    libopengl0 \
    libvulkan1 \
    patchelf \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Setup uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
# copy モードで .venv を自己完結させる（キャッシュはイメージに焼かずマウントで渡す）
ENV UV_LINK_MODE=copy
RUN echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc

# 作業ディレクトリの設定
WORKDIR /workspace

# pyproject.tomlとuv.lockをコピー
COPY . .

# uv キャッシュ（この依存セットで ~60GB）がイメージ肥大化の主因。
# BuildKit の cache mount でキャッシュをレイヤー外に追い出し、最終イメージには
# 19GB の .venv だけを残す。--mount により /root/.cache/uv はイメージに焼かれない。
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --refresh --preview-features extra-build-dependencies

# デフォルトコマンド
CMD ["bash"]
