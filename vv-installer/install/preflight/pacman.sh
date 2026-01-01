#!/bin/bash
# Configure pacman before installation

show_info "$MSG_SETUP_PACMAN"

# Update package database
sudo pacman -Sy --noconfirm

# Enable parallel downloads
if ! grep -q "^ParallelDownloads" /etc/pacman.conf; then
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
  show_success "$MSG_PACMAN_PARALLEL"
fi

# Enable Color
if ! grep -q "^Color" /etc/pacman.conf; then
  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
fi

show_success "$MSG_PACMAN_OK"
