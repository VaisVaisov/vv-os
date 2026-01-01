#!/bin/bash
# Configure GameMode

show_info "$MSG_SETUP_GAMEMODE"

# Copy system config (GPU settings for NVIDIA)
if [[ -f "$VV_CONFIGS/gamemode/gamemode.ini" ]]; then
  sudo cp "$VV_CONFIGS/gamemode/gamemode.ini" /etc/gamemode.ini
fi

# Copy user config (CPU settings + notifications)
if [[ -f "$VV_CONFIGS/gamemode/gamemode-user.ini" ]]; then
  mkdir -p ~/.config
  cp "$VV_CONFIGS/gamemode/gamemode-user.ini" ~/.config/gamemode.ini
fi

show_success "$MSG_GAMEMODE_OK"
