#!/bin/bash
# Install Floorp Browser (privacy-focused Firefox fork with PWA support)

show_info "$MSG_INSTALL_BROWSER"

# Install Flatpak if not already installed
if ! command -v flatpak &>/dev/null; then
  show_info "$MSG_INSTALL_FLATPAK"
  sudo pacman -S --noconfirm --needed flatpak
fi

# Add Flathub repository
show_info "$MSG_ADD_FLATHUB"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Floorp Browser
show_info "$MSG_INSTALL_FLOORP"
flatpak install flathub one.ablaze.floorp -y

show_success "$MSG_BROWSER_OK"
