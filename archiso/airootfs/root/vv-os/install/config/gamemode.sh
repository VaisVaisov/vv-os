#!/bin/bash
# Configure GameMode

show_info "$MSG_SETUP_GAMEMODE"

# Copy system config (GPU settings for NVIDIA)
if [[ -f "$VV_CONFIGS/gamemode/gamemode.ini" ]]; then
  sudo cp "$VV_CONFIGS/gamemode/gamemode.ini" /etc/gamemode.ini
fi

# Copy user config (CPU settings + notifications)
if [[ -f "$VV_CONFIGS/gamemode/gamemode-user.ini" ]]; then
  mkdir -p $VV_USER_HOME/.config
  cp "$VV_CONFIGS/gamemode/gamemode-user.ini" $VV_USER_HOME/.config/gamemode.ini
fi

# Fix ownership
chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.local" "$VV_USER_HOME/.config" 2>/dev/null || true

show_success "$MSG_GAMEMODE_OK"
