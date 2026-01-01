#!/bin/bash
# Check and install base system packages

show_info "$MSG_CHECKING_BASE"

mapfile -t packages < <(grep -v '^#' "$VV_PACKAGES/vv-base-system.txt" | grep -v '^$')

if [ ${#packages[@]} -gt 0 ]; then
  sudo pacman -S --noconfirm --needed "${packages[@]}"
  show_success "$MSG_BASE_CHECKED"
fi
