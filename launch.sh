#!/bin/bash
# Launch the container built from this template's Dockerfile.
#
# Build first:
#     DOCKER_BUILDKIT=1 docker build -t isaac_uv_template:latest .
#
# Image / container names can be overridden via env vars, e.g.:
#     IMAGE=myimg:dev NAME=myrun ./launch.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IMAGE="${IMAGE:-isaac_uv_template:latest}"
NAME="${NAME:-isaac_uv}"
# Host-side port for the viser web viewer. Override if 8080 is already taken
# on this machine (e.g. PORT=8081 ./launch.sh) -- check with `ss -ltn`.
PORT="${PORT:-8080}"

# For a local GUI app you'd export DISPLAY and `xhost +local:` first. On vast.ai /
# headless hosts the viser web viewer (port 8080) is the usual way to "play".
#export DISPLAY=:1
#xhost +

# source/ is where cloned RL repos (e.g. unitree_rl_lab) live. .venv sits at
# /workspace/.venv, outside source/, so this mount doesn't touch the
# image-baked venv -- it only persists cloned repos, their edits, and any
# repo-relative logs/outputs across container restarts.
# New repo checklist: clone into source/, add it to the root pyproject.toml's
# [tool.uv.workspace] members, then `uv sync --preview-features extra-build-dependencies`.
docker run --rm -it --gpus all --runtime=nvidia \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e "ACCEPT_EULA=Y" \
  -p "${PORT}:8080" \
  -v "${SCRIPT_DIR}/source:/workspace/source" \
  --name "$NAME" \
  "$IMAGE"
