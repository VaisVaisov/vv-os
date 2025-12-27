#!/bin/bash
# Установка Hyprland + Noctalia Shell

show_info "$MSG_INSTALL_SHELL"

# Читаем пакеты из файлов
mapfile -t official < <(grep -v '^#' "$VV_PACKAGES/vv-shell-desktop-official.txt" | grep -v '^$')
mapfile -t aur < <(grep -v '^#' "$VV_PACKAGES/vv-shell-desktop-aur.txt" | grep -v '^$')

# Устанавливаем official пакеты
if [ ${#official[@]} -gt 0 ]; then
  show_info "$MSG_INSTALL_SHELL_OFFICIAL"
  sudo pacman -S --noconfirm --needed "${official[@]}"
fi

# Устанавливаем AUR пакеты (Hyprland стек в правильном порядке)
if [ ${#aur[@]} -gt 0 ]; then
  show_info "$MSG_INSTALL_SHELL_AUR"
  paru -S --noconfirm --needed "${aur[@]}"
fi

show_success "$MSG_SHELL_OK"
