#!/bin/bash
# Установка игровых пакетов (опционально)

show_info "$MSG_INSTALL_GAMING"

# Спрашиваем пользователя
if ! gum confirm "$MSG_CONFIRM_GAMING"; then
  show_info "$MSG_SKIP_GAMING"
  return 0
fi

# Читаем пакеты
mapfile -t official < <(grep -v '^#' "$VV_PACKAGES/vv-gaming-official.txt" | grep -v '^$')
mapfile -t aur < <(grep -v '^#' "$VV_PACKAGES/vv-gaming-aur.txt" | grep -v '^$')

# Устанавливаем
if [ ${#official[@]} -gt 0 ]; then
  sudo pacman -S --noconfirm --needed "${official[@]}"
fi

if [ ${#aur[@]} -gt 0 ]; then
  paru -S --noconfirm --needed "${aur[@]}"
fi

show_success "$MSG_GAMING_OK"
