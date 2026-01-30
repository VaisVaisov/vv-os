#!/bin/bash
# Helper to install AUR packages using yay with passwordless sudo for builduser

# Setup builduser with passwordless sudo for makepkg, pacman, and yay (idempotent)
setup_builduser() {
    if ! id -u builduser &>/dev/null; then
        show_info "$MSG_HELPER_AUR_CREATE_USER"
        useradd -m builduser

        # Configure sudoers for passwordless makepkg, pacman, and yay
        echo "builduser ALL = (root) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman, /usr/bin/yay" > /etc/sudoers.d/02_builduser
        chmod 440 /etc/sudoers.d/02_builduser

        show_success "$MSG_HELPER_AUR_USER_CONFIGURED"
    fi
}

# Install a single AUR package using yay (handles all dependencies automatically)
install_aur_package() {
    local pkg="$1"
    show_info "$MSG_AUR_BUILDING $pkg"

    # Setup builduser if not exists (yay should already be installed by aur-helper.sh)
    setup_builduser

    # Install package using yay as builduser (automatic dependency resolution)
    if ! sudo -u builduser yay -S --noconfirm --needed "$pkg"; then
        show_error "$MSG_AUR_INSTALL_FAILED: $pkg"
        return 1
    fi

    show_success "$MSG_HELPER_AUR_INSTALLED: $pkg"
}

# Cleanup temporary build user (call this ONCE at the end of all AUR installations)
cleanup_builduser() {
    if id -u builduser &>/dev/null; then
        show_info "$MSG_AUR_CLEANUP"

        # Remove sudoers.d file
        rm -f /etc/sudoers.d/02_builduser

        # Remove builduser
        userdel -r builduser 2>/dev/null || true

        show_success "$MSG_HELPER_AUR_CLEANUP"
    fi
}
