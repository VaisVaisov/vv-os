#!/bin/bash
# Установка обоев

show_info "$MSG_INSTALL_WALLPAPERS"

# Создаем директорию для обоев
mkdir -p ~/Pictures/Wallpapers

# Проверяем наличие архива с обоями
if [[ -f "$VV_ASSETS/wallpapers/wallpapers.zip" ]]; then
  show_info "$MSG_EXTRACT_WALLPAPERS"
  unzip -o "$VV_ASSETS/wallpapers/wallpapers.zip" -d ~/Pictures/Wallpapers/
  show_success "$MSG_WALLPAPERS_EXTRACTED"
# Если архива нет, копируем файлы напрямую
elif [[ -d "$VV_ASSETS/wallpapers" ]]; then
  show_info "$MSG_COPY_WALLPAPERS"
  cp "$VV_ASSETS/wallpapers/"*.{png,jpg,jpeg} ~/Pictures/Wallpapers/ 2>/dev/null || true
  show_success "$MSG_WALLPAPERS_COPIED"
else
  show_info "$MSG_WALLPAPERS_NOT_FOUND"
fi

show_success "$MSG_WALLPAPERS_OK"
