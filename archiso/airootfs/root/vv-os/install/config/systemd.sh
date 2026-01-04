#!/bin/bash
# Configure systemd services

show_info "$MSG_SETUP_SYSTEMD"

# Create systemd directories for user
mkdir -p "$VV_USER_HOME/.config/systemd/user"
sudo mkdir -p /etc/systemd/system

# Install Noctalia service for user
if [[ -f "$VV_CONFIGS/systemd/user/noctalia.service" ]]; then
  cp "$VV_CONFIGS/systemd/user/noctalia.service" "$VV_USER_HOME/.config/systemd/user/"
fi

# Install Noctalia override
if [[ -f "$VV_CONFIGS/systemd/user/noctalia.service.d/override.conf" ]]; then
  mkdir -p "$VV_USER_HOME/.config/systemd/user/noctalia.service.d"
  cp "$VV_CONFIGS/systemd/user/noctalia.service.d/override.conf" "$VV_USER_HOME/.config/systemd/user/noctalia.service.d/"
fi

# Fix ownership
chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.config/systemd"

# Install update-mirrors service and timer
if [[ -f "$VV_CONFIGS/systemd/system/update-mirrors.service" ]]; then
  sudo cp "$VV_CONFIGS/systemd/system/update-mirrors.service" /etc/systemd/system/
fi

if [[ -f "$VV_CONFIGS/systemd/system/update-mirrors.timer" ]]; then
  sudo cp "$VV_CONFIGS/systemd/system/update-mirrors.timer" /etc/systemd/system/
fi

# Install plymouth override
if [[ -f "$VV_CONFIGS/systemd/plymouth-quit.service.d/override.conf" ]]; then
  sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d
  sudo cp "$VV_CONFIGS/systemd/plymouth-quit.service.d/override.conf" /etc/systemd/system/plymouth-quit.service.d/
fi

# Install logind configuration (ignore power button for NS to handle it)
if [[ -d "$VV_CONFIGS/systemd/logind.conf.d" ]]; then
  sudo mkdir -p /etc/systemd/logind.conf.d
  sudo cp -r "$VV_CONFIGS/systemd/logind.conf.d/"* /etc/systemd/logind.conf.d/
  show_success "logind.conf.d configuration installed"
fi

# Reload systemd daemon
sudo systemctl daemon-reload 2>/dev/null || true

# Reload user systemd (only if D-Bus session available - works in installed system, not in chroot)
if [[ -n "$DBUS_SESSION_BUS_ADDRESS" ]] && [[ -n "$XDG_RUNTIME_DIR" ]]; then
  systemctl --user daemon-reload 2>/dev/null || true
fi

# Enable Noctalia service for user
# Create symlink manually since systemctl --user doesn't work in chroot
# Note: noctalia.service is installed by noctalia-shell-git package to /usr/lib/systemd/user/
# We only override it with ~/.config/systemd/user/noctalia.service.d/override.conf
NOCTALIA_SERVICE_SYSTEM="/usr/lib/systemd/user/noctalia.service"
if [[ -f "$NOCTALIA_SERVICE_SYSTEM" ]]; then
  # Use default.target as specified in override.conf
  mkdir -p "$VV_USER_HOME/.config/systemd/user/default.target.wants"
  ln -sf "$NOCTALIA_SERVICE_SYSTEM" "$VV_USER_HOME/.config/systemd/user/default.target.wants/noctalia.service"
  chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.config/systemd/user/default.target.wants"
  show_success "Noctalia service enabled for $VV_USER"
else
  show_info "Warning: noctalia.service not found in /usr/lib/systemd/user/ (will be installed by noctalia-shell-git package)"
fi

# Enable update-mirrors timer (weekly mirrorlist updates)
if [[ -f "/etc/systemd/system/update-mirrors.timer" ]]; then
  sudo systemctl enable update-mirrors.timer
fi

# Enable power management and ACPI services
show_info "Enabling power management services..."

# ACPI daemon (for power button, lid close events)
if pacman -Q acpid &> /dev/null; then
  sudo systemctl enable acpid.service
  show_success "acpid.service enabled"
fi

# TLP power management (for laptops)
if pacman -Q tlp &> /dev/null; then
  sudo systemctl enable tlp.service
  show_success "tlp.service enabled"
fi

# UPower (battery monitoring)
if pacman -Q upower &> /dev/null; then
  sudo systemctl enable upower.service
  show_success "upower.service enabled"
fi

# NetworkManager (network management)
if pacman -Q networkmanager &> /dev/null; then
  sudo systemctl enable NetworkManager.service
  show_success "NetworkManager.service enabled"
fi

# Bluetooth
if pacman -Q bluez &> /dev/null; then
  sudo systemctl enable bluetooth.service
  show_success "bluetooth.service enabled"
fi

show_success "$MSG_SYSTEMD_OK"
