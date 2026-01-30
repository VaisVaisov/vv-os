#!/bin/bash
# Install package managers and utilities for them

show_info "$MSG_PACKAGING_PM_INSTALL"

# Install AUR packages
mapfile -t aur < <(grep -v '^#' "$VV_PACKAGES/vv-package-managers-aur.txt" | grep -v '^$')
if [ ${#aur[@]} -gt 0 ]; then
  show_info "$MSG_PACKAGING_PM_AUR"
  for pkg in "${aur[@]}"; do
    install_aur_package "$pkg"
  done
fi

# Install official packages
mapfile -t official < <(grep -v '^#' "$VV_PACKAGES/vv-package-managers-official.txt" | grep -v '^$')
if [ ${#official[@]} -gt 0 ]; then
  show_info "$MSG_PACKAGING_PM_OFFICIAL"
  sudo pacman -S --noconfirm --needed "${official[@]}"
fi

# Clean up temporary build user created during AUR package installation
cleanup_builduser
