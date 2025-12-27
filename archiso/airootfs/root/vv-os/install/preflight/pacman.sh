#!/bin/bash
# Настройка pacman перед установкой

show_info "$MSG_SETUP_PACMAN"

# Обновление базы данных
sudo pacman -Sy --noconfirm

# Включаем параллельную загрузку
if ! grep -q "^ParallelDownloads" /etc/pacman.conf; then
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
  show_success "$MSG_PACMAN_PARALLEL"
fi

# Включаем Color
if ! grep -q "^Color" /etc/pacman.conf; then
  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
fi

show_success "$MSG_PACMAN_OK"
