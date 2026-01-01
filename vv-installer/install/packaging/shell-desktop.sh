#!/bin/bash
# Install Hyprland + Noctalia Shell stack from both official repos and AUR (git versions)

show_info "$MSG_INSTALL_SHELL"

# Install AUR packages (Hyprland git stack)
mapfile -t aur < <(grep -v '^#' "$VV_PACKAGES/vv-shell-desktop-aur.txt" | grep -v '^$')
if [ ${#aur[@]} -gt 0 ]; then
  show_info "$MSG_INSTALL_SHELL_AUR"
  for pkg in "${aur[@]}"; do
    install_aur_package "$pkg"
  done
fi

# Install official packages
mapfile -t official < <(grep -v '^#' "$VV_PACKAGES/vv-shell-desktop-official.txt" | grep -v '^$')
if [ ${#official[@]} -gt 0 ]; then
  show_info "$MSG_INSTALL_SHELL_OFFICIAL"
  sudo pacman -S --noconfirm --needed "${official[@]}"
fi

# Clean up temporary build user created during AUR package installation
cleanup_builduser

show_success "$MSG_SHELL_OK"
