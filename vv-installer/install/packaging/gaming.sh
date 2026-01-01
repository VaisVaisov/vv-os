#!/bin/bash
# Install gaming packages (optional)

show_info "$MSG_INSTALL_GAMING"

if ! gum confirm "$MSG_CONFIRM_GAMING"; then
  show_info "$MSG_SKIP_GAMING"
  return 0
fi

# Official packages
mapfile -t official < <(grep -v '^#' "$VV_PACKAGES/vv-gaming-official.txt" | grep -v '^$')
if [ ${#official[@]} -gt 0 ]; then
  sudo pacman -S --noconfirm --needed "${official[@]}"
fi

# AUR packages
mapfile -t aur < <(grep -v '^#' "$VV_PACKAGES/vv-gaming-aur.txt" | grep -v '^$')
for pkg in "${aur[@]}"; do
  install_aur_package "$pkg"
done

cleanup_builduser
show_success "$MSG_GAMING_OK"
