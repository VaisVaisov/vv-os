#!/bin/bash
# Копирование Hyprland конфигов

show_info "$MSG_SETUP_HYPRLAND"

# Копируем модульные конфиги
mkdir -p ~/.config/hypr
cp -R "$VV_CONFIGS/hypr/"* ~/.config/hypr/

show_success "$MSG_HYPRLAND_OK"
