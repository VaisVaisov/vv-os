#!/bin/bash
# Configure systemd services

show_info "$MSG_SETUP_SYSTEMD"

# Create systemd directories for user
mkdir -p "$VV_USER_HOME/.config/systemd/user"
sudo mkdir -p /etc/systemd/system

# NOTE: Noctalia systemd service configs are no longer installed
# Noctalia Shell is launched via Hyprland autostart instead (see hypr/autostart.conf)

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
  show_success "$MSG_CONFIG_SYSTEMD_LOGIND"
fi

# Install kernel modules configuration (ip_tables for Docker, etc.)
if [[ -d "$VV_CONFIGS/modules-load.d" ]]; then
  sudo mkdir -p /etc/modules-load.d
  sudo cp -r "$VV_CONFIGS/modules-load.d/"* /etc/modules-load.d/
  show_success "$MSG_CONFIG_SYSTEMD_MODULES"
fi

# Reload systemd daemon
sudo systemctl daemon-reload 2>/dev/null || true

# Reload user systemd (only if D-Bus session available - works in installed system, not in chroot)
if [[ -n "$DBUS_SESSION_BUS_ADDRESS" ]] && [[ -n "$XDG_RUNTIME_DIR" ]]; then
  systemctl --user daemon-reload 2>/dev/null || true
fi

# NOTE: Noctalia Shell is now launched via Hyprland autostart (see hypr/autostart.conf)
# instead of systemd service to avoid race conditions with WAYLAND_DISPLAY environment variable

# Enable update-mirrors timer (weekly mirrorlist updates)
if [[ -f "/etc/systemd/system/update-mirrors.timer" ]]; then
  sudo systemctl enable update-mirrors.timer
fi

# Enable power management and ACPI services
show_info "$MSG_CONFIG_SYSTEMD_POWER"

# ACPI daemon (for power button, lid close events)
if pacman -Q acpid &> /dev/null; then
  sudo systemctl enable acpid.service
  show_success "$MSG_CONFIG_SYSTEMD_ACPID"
fi

# TLP power management (for laptops)
if pacman -Q tlp &> /dev/null; then
  sudo systemctl enable tlp.service
  show_success "$MSG_CONFIG_SYSTEMD_TLP"

  # Enable TLP Power Profiles Daemon for NS integration
  if pacman -Q tlp-pd &> /dev/null; then
    sudo systemctl enable tlp-pd.service
    show_success "$MSG_CONFIG_SYSTEMD_TLP_PD"
  fi
fi

# UPower (battery monitoring)
if pacman -Q upower &> /dev/null; then
  sudo systemctl enable upower.service
  show_success "$MSG_CONFIG_SYSTEMD_UPOWER"
fi

# NetworkManager (network management)
if pacman -Q networkmanager &> /dev/null; then
  sudo systemctl enable NetworkManager.service
  show_success "$MSG_CONFIG_SYSTEMD_NM"

  # Disable NetworkManager-wait-online to speed up boot
  # This service blocks boot waiting for network, which is unnecessary on desktop
  sudo systemctl disable NetworkManager-wait-online.service 2>/dev/null || true
  show_success "$MSG_CONFIG_SYSTEMD_NM_WAIT"
fi

# Disable systemd-networkd-wait-online to speed up boot
# This service can slow down boot by 2+ minutes waiting for network timeout
if systemctl list-unit-files | grep -q systemd-networkd-wait-online.service 2>/dev/null; then
  sudo systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
  show_success "$MSG_CONFIG_SYSTEMD_NETWORKD_WAIT"
fi

# Bluetooth
if pacman -Q bluez &> /dev/null; then
  sudo systemctl enable bluetooth.service
  show_success "$MSG_CONFIG_SYSTEMD_BLUETOOTH"
fi

show_success "$MSG_SYSTEMD_OK"
