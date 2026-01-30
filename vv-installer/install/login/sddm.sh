#!/bin/bash
# Configure SDDM display manager

show_info "$MSG_SETUP_SDDM"

# Check if SDDM is installed
if ! command -v sddm &>/dev/null; then
  show_info "$MSG_SDDM_NOT_INSTALLED"
  sudo pacman -S --needed --noconfirm sddm
fi

# Install dependencies for Qt6 themes
show_info "$MSG_INSTALL_SDDM_DEPS"
sudo pacman -S --needed --noconfirm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg

# Create config directory
sudo mkdir -p /etc/sddm.conf.d

# Install sddm-astronaut-theme
if [[ ! -d "/usr/share/sddm/themes/sddm-astronaut-theme" ]]; then
  show_info "$MSG_INSTALL_SDDM_THEME"
  install_aur_package "sddm-astronaut-theme"
  cleanup_builduser
  show_success "$MSG_SDDM_THEME_OK"
fi

# Configure theme to use cyberpunk.conf
METADATA_FILE="/usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
if [[ -f "$METADATA_FILE" ]]; then
  show_info "$MSG_SDDM_CONFIGURE_THEME"
  sudo sed -i 's|ConfigFile=Themes/astronaut.conf|ConfigFile=Themes/cyberpunk.conf|' "$METADATA_FILE"
  show_success "$MSG_SDDM_THEME_CONFIGURED"
fi

# Copy theme config
if [[ -f "$VV_CONFIGS/boot/sddm.conf" ]]; then
  sudo cp "$VV_CONFIGS/boot/sddm.conf" /etc/sddm.conf.d/theme.conf
  show_success "$MSG_SDDM_CONFIG_COPIED"
fi

# Enable SDDM service
if ! systemctl is-enabled sddm.service &>/dev/null; then
  sudo systemctl enable sddm.service
  show_success "$MSG_SDDM_SERVICE_ENABLED"
fi

show_success "$MSG_SDDM_OK"
