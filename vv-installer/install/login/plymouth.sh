#!/bin/bash
# Configure Plymouth boot splash

show_info "$MSG_SETUP_PLYMOUTH"

# Check if Plymouth is installed
if ! command -v plymouth &>/dev/null; then
  show_info "$MSG_PLYMOUTH_NOT_INSTALLED"
  sudo pacman -S --needed --noconfirm plymouth
fi

# Copy plymouthd config
if [[ -f "$VV_CONFIGS/boot/plymouthd.conf" ]]; then
  sudo mkdir -p /etc/plymouth
  sudo cp "$VV_CONFIGS/boot/plymouthd.conf" /etc/plymouth/plymouthd.conf
  show_success "$MSG_PLYMOUTH_CONFIG_COPIED"
fi

# Install Plymouth themes (if not already installed)
if ! plymouth-set-default-theme -l | grep -q "cybernetic"; then
  show_info "$MSG_INSTALL_PLYMOUTH_THEMES"
  paru -S --needed --noconfirm plymouth-themes-adi1090x-git
fi

# Set cybernetic theme
CURRENT_THEME=$(plymouth-set-default-theme)
if [ "$CURRENT_THEME" != "cybernetic" ]; then
  show_info "$MSG_SET_PLYMOUTH_THEME"
  sudo plymouth-set-default-theme cybernetic
  show_success "$MSG_PLYMOUTH_THEME_OK"
fi

# Configure mkinitcpio hooks
show_info "$MSG_SETUP_MKINITCPIO"

# Check if plymouth is in HOOKS
if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
  # Add plymouth after systemd (if systemd exists) or after udev
  if grep -q "systemd" /etc/mkinitcpio.conf; then
    # systemd must come BEFORE plymouth
    sudo sed -i 's/\(HOOKS=([^)]*systemd[^)]*\)\(autodetect\)/\1 plymouth \2/' /etc/mkinitcpio.conf
  else
    # Or after base udev if no systemd
    sudo sed -i 's/\(HOOKS=([^)]*udev[^)]*\)\(autodetect\)/\1 plymouth \2/' /etc/mkinitcpio.conf
  fi

  show_success "$MSG_PLYMOUTH_HOOKS_ADDED"

  # Rebuild initramfs
  show_info "$MSG_REBUILD_INITRAMFS"
  sudo mkinitcpio -P
  show_success "$MSG_INITRAMFS_REBUILT"
else
  show_success "$MSG_PLYMOUTH_HOOK_EXISTS"
fi

# Create override for smooth Plymouth → SDDM transition
sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d
cat <<EOF | sudo tee /etc/systemd/system/plymouth-quit.service.d/override.conf >/dev/null
[Unit]
Before=display-manager.service
EOF

show_success "$MSG_PLYMOUTH_OK"
