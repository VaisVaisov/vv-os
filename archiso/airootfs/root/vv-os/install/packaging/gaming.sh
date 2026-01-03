#!/bin/bash
# Install gaming packages (optional)

show_info "$MSG_INSTALL_GAMING"

# Show package lists
if [[ -f "$VV_PACKAGES/vv-gaming-official.txt" ]]; then
  echo ""
  show_info "Official gaming packages:"
  grep -v '^#' "$VV_PACKAGES/vv-gaming-official.txt" | grep -v '^$' | sed 's/^/  • /'
  echo ""
fi

if [[ -f "$VV_PACKAGES/vv-gaming-aur.txt" ]]; then
  echo ""
  show_info "AUR gaming packages:"
  grep -v '^#' "$VV_PACKAGES/vv-gaming-aur.txt" | grep -v '^$' | sed 's/^/  • /'
  echo ""
fi

if ! gum confirm "$MSG_CONFIRM_GAMING"; then
  show_info "$MSG_SKIP_GAMING"
  return 0
fi

# Update package database (ensure multilib packages are available)
sudo pacman -Sy --noconfirm

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
