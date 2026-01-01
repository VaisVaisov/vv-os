#!/bin/bash
# Install yay AUR helper manually (bootstrap)

show_info "Installing yay AUR helper..."

# Create builduser if not exists
if ! id -u builduser &>/dev/null; then
    useradd -m builduser
fi

# Configure sudoers for passwordless makepkg and pacman
echo "builduser ALL = (root) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman, /usr/bin/yay" > /etc/sudoers.d/02_builduser
chmod 440 /etc/sudoers.d/02_builduser

# Clone and build yay
cd /tmp || exit 1
rm -rf yay

if ! sudo -u builduser git clone --depth=1 https://aur.archlinux.org/yay.git; then
    show_error "Failed to clone yay from AUR"
    exit 1
fi

cd yay || exit 1
chown -R builduser:builduser .

# Build yay as builduser
if ! sudo -u builduser makepkg --noconfirm -si; then
    show_error "Failed to build yay"
    exit 1
fi

# Cleanup
cd /tmp
rm -rf yay

show_success "yay installed successfully"
