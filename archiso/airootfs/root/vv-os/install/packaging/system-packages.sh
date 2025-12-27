#!/bin/bash
# Установка системных пакетов (audio, network, utilities)

show_info "$MSG_INSTALL_SYSTEM"

# Читаем категории
categories=(
  "audio"
  "network"
  "system-utilities"
  "terminal"
  "file-manager"
)

for category in "${categories[@]}"; do
  file="$VV_PACKAGES/vv-${category}.txt"

  if [[ -f "$file" ]]; then
    mapfile -t packages < <(grep -v '^#' "$file" | grep -v '^$')

    if [ ${#packages[@]} -gt 0 ]; then
      show_info "$MSG_INSTALLING_CATEGORY ${category}..."
      sudo pacman -S --noconfirm --needed "${packages[@]}"
    fi
  fi
done

show_success "$MSG_SYSTEM_OK"
