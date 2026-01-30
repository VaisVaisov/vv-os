#!/bin/bash
# Install user and system scripts

show_info "$MSG_INSTALL_SCRIPTS"

# Create directory for user scripts
mkdir -p $VV_USER_HOME/.local/bin

# Install all vv-* scripts
if [[ -d "$VV_SCRIPTS" ]]; then
  cp "$VV_SCRIPTS/"vv-* $VV_USER_HOME/.local/bin/ 2>/dev/null || true

  # Set executable permissions
  chmod +x $VV_USER_HOME/.local/bin/vv-* 2>/dev/null || true
fi

# Install system-wide scripts
if [[ -d "$VV_CONFIGS/scripts" ]]; then
  sudo cp "$VV_CONFIGS/scripts/prime-launcher" /usr/local/bin/ 2>/dev/null || true
  sudo cp "$VV_CONFIGS/scripts/update-mirrors.sh" /usr/local/bin/ 2>/dev/null || true

  sudo chmod +x /usr/local/bin/prime-launcher 2>/dev/null || true
  sudo chmod +x /usr/local/bin/update-mirrors.sh 2>/dev/null || true

  # Create symlinks without .sh extension (cosmetic improvement)
  sudo ln -sf /usr/local/bin/update-mirrors.sh /usr/local/bin/update-mirrors 2>/dev/null || true
fi

# Install .desktop files for Noctalia launcher
show_info "$MSG_INSTALL_DESKTOP_FILES"
mkdir -p $VV_USER_HOME/.local/share/applications

if [[ -d "$VV_CONFIGS/applications" ]]; then
  cp "$VV_CONFIGS/applications/"*.desktop $VV_USER_HOME/.local/share/applications/ 2>/dev/null || true
  chmod 644 $VV_USER_HOME/.local/share/applications/vv-*.desktop 2>/dev/null || true

  # Fix script paths to absolute paths (required for NS launcher)
  for script in vv-package-manager vv-aur-search vv-flatpak-search vv-pacman-search vv-tui-install vv-webapp-install vv-snapper-manager; do
    if [[ -f "$VV_USER_HOME/.local/share/applications/$script.desktop" ]]; then
      sed -i "s| $script| $VV_USER_HOME/.local/bin/$script|g" "$VV_USER_HOME/.local/share/applications/$script.desktop"
    fi
  done
fi

# Update application database
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database $VV_USER_HOME/.local/share/applications 2>/dev/null || true
fi

# Fix ownership
chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.local" "$VV_USER_HOME/.config" 2>/dev/null || true

show_success "$MSG_SCRIPTS_INSTALLED"
