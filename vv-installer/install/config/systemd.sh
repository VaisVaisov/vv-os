#!/bin/bash
# Configure systemd services

show_info "$MSG_SETUP_SYSTEMD"

# Create systemd directories
mkdir -p ~/.config/systemd/user
sudo mkdir -p /etc/systemd/system

# Install Noctalia service
if [[ -f "$VV_CONFIGS/systemd/noctalia.service" ]]; then
  cp "$VV_CONFIGS/systemd/noctalia.service" ~/.config/systemd/user/
fi

# Install Noctalia override
if [[ -f "$VV_CONFIGS/systemd/noctalia.service.d/override.conf" ]]; then
  mkdir -p ~/.config/systemd/user/noctalia.service.d
  cp "$VV_CONFIGS/systemd/noctalia.service.d/override.conf" ~/.config/systemd/user/noctalia.service.d/
fi

# Install update-mirrors service and timer
if [[ -f "$VV_CONFIGS/systemd/update-mirrors.service" ]]; then
  sudo cp "$VV_CONFIGS/systemd/update-mirrors.service" /etc/systemd/system/
fi

if [[ -f "$VV_CONFIGS/systemd/update-mirrors.timer" ]]; then
  sudo cp "$VV_CONFIGS/systemd/update-mirrors.timer" /etc/systemd/system/
fi

# Install plymouth override
if [[ -f "$VV_CONFIGS/systemd/plymouth-quit.service.d/override.conf" ]]; then
  sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d
  sudo cp "$VV_CONFIGS/systemd/plymouth-quit.service.d/override.conf" /etc/systemd/system/plymouth-quit.service.d/
fi

# Reload systemd (only outside chroot)
if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
  systemctl --user daemon-reload
  sudo systemctl daemon-reload
fi

# Enable Noctalia service
if [[ -n "${VV_CHROOT_INSTALL:-}" ]]; then
  # In chroot, service is enabled during user creation or first login
  show_info "$MSG_ENABLE_NOCTALIA"
else
  systemctl --user enable noctalia.service
fi

# Enable update-mirrors timer
sudo systemctl enable update-mirrors.timer

show_success "$MSG_SYSTEMD_OK"
