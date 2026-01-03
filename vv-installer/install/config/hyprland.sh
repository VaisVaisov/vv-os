#!/bin/bash
# Install Hyprland configuration files

show_info "$MSG_SETUP_HYPRLAND"

# Copy modular configs to user's home
mkdir -p "$VV_USER_HOME/.config/hypr"
cp -R "$VV_CONFIGS/hypr/"* "$VV_USER_HOME/.config/hypr/"
chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.config/hypr"

show_success "$MSG_HYPRLAND_OK"
