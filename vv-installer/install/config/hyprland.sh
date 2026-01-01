#!/bin/bash
# Install Hyprland configuration files

show_info "$MSG_SETUP_HYPRLAND"

# Copy modular configs
mkdir -p ~/.config/hypr
cp -R "$VV_CONFIGS/hypr/"* ~/.config/hypr/

show_success "$MSG_HYPRLAND_OK"
