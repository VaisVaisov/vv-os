#!/bin/bash
# Install Electron frameworks (needed for many applications)

show_info "$MSG_INSTALLING_ELECTRON"

# Official repositories
if [[ -f "$VV_PACKAGES/vv-electron-official.txt" ]]; then
    show_info "$MSG_INSTALLING_ELECTRON_OFFICIAL"
    mapfile -t official < <(grep -v '^#' "$VV_PACKAGES/vv-electron-official.txt" | grep -v '^$')
    if [ ${#official[@]} -gt 0 ]; then
        show_info "$MSG_INSTALL_SHELL_OFFICIAL"
        sudo pacman -S --noconfirm --needed "${official[@]}"
    fi
fi

# AUR
if [[ -f "$VV_PACKAGES/vv-electron-aur.txt" ]]; then
    show_info "$MSG_INSTALLING_ELECTRON_AUR"
    mapfile -t aur < <(grep -v '^#' "$VV_PACKAGES/vv-electron-aur.txt" | grep -v '^$')
    if [ ${#aur[@]} -gt 0 ]; then
    for pkg in "${aur[@]}"; do
        install_aur_package "$pkg"
    done
    fi
fi



show_success "$MSG_ELECTRON_OK"
