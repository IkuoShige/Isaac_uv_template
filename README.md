# isaac_ws

isaacsim: 6.0.1.0
isaaclab: 3.0.0-beta2 (post1)

```bash
uv sync --refresh --preview-features extra-build-dependencies
```

torch/torchvision are pinned to the cu128 build (2.11.0 / 0.26.0) via `tool.uv.sources`
in `source/isaaclab_extension/pyproject.toml`, so no manual reinstall step is needed.

## non-display
```bash
apt-get update && apt-get install -y \
    libglu1-mesa \
    libopengl0 \
    xvfb && \
Xvfb :99 -screen 0 1920x1080x24 &
# .bashrcに追加
export DISPLAY=:99
```

## cannot input Japanese
vim ~/.bashrc
```bash
# Keep interactive shells on UTF-8 so tmux panes can handle Japanese text.
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
```
source ~/.bashrc
vim ~/.tmux.conf
```bash
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm*:Tc"

# Preserve UTF-8 locale variables for shells started inside tmux.
set -g update-environment "DISPLAY SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY LANG LC_ALL LC_CTYPE"
set-environment -g LANG C.UTF-8
set-environment -g LC_ALL C.UTF-8
set-environment -g LC_CTYPE C.UTF-8
```

