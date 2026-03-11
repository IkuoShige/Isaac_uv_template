# isaac_ws

isaacsim: 5.1.0
isaaclab: 2.3.0

```bash
uv sync --refresh --preview-features extra-build-dependencies
```

## 5090 torch
```bash
uv pip uninstall torch torchvision torchaudio
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

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

