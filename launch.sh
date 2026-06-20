#!/bin/bash
# Launch the container built from this template's Dockerfile.
#
# Build first:
#     DOCKER_BUILDKIT=1 docker build -t isaac_uv_template:latest .
#
# Image / container names can be overridden via env vars, e.g.:
#     IMAGE=myimg:dev NAME=myrun ./launch.sh
set -euo pipefail

IMAGE="${IMAGE:-isaac_uv_template:latest}"
NAME="${NAME:-isaac_uv}"

# For a local GUI app you'd export DISPLAY and `xhost +local:` first. On vast.ai /
# headless hosts the viser web viewer (port 8080) is the usual way to "play".
#export DISPLAY=:1
#xhost +

docker run --rm -it --gpus all --runtime=nvidia \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e "ACCEPT_EULA=Y" \
  -p 8080:8080 \
  --name "$NAME" \
  "$IMAGE"
