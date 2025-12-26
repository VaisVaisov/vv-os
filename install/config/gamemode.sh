#!/bin/bash
# Настройка GameMode

show_info "$MSG_SETUP_GAMEMODE"

# Копируем системный конфиг (GPU настройки для NVIDIA)
if [[ -f "$VV_CONFIGS/gamemode/gamemode.ini" ]]; then
  sudo cp "$VV_CONFIGS/gamemode/gamemode.ini" /etc/gamemode.ini
fi

# Копируем пользовательский конфиг (CPU настройки + уведомления)
if [[ -f "$VV_CONFIGS/gamemode/gamemode-user.ini" ]]; then
  mkdir -p ~/.config
  cp "$VV_CONFIGS/gamemode/gamemode-user.ini" ~/.config/gamemode.ini
fi

show_success "$MSG_GAMEMODE_OK"
