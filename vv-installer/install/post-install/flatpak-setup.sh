#!/bin/bash
# Setup Flatpak and enable Flathub repository

show_info "$MSG_FLATPAK_SETUP"

# Check if flatpak is installed
if ! command -v flatpak &>/dev/null; then
    show_warning "$MSG_FLATPAK_NOT_INSTALLED"
    return 0
fi

# Add Flathub repository
show_info "$MSG_FLATPAK_ADD_FLATHUB"
if ! flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>/dev/null; then
    show_warning "$MSG_FLATPAK_FLATHUB_WARNING"
fi

show_success "$MSG_FLATPAK_OK"
