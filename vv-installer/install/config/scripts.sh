#!/bin/bash
# Install user and system scripts

show_info "$MSG_INSTALL_SCRIPTS"

# Create directory for user scripts
mkdir -p ~/.local/bin

# Install all vv-* scripts
if [[ -d "$VV_SCRIPTS" ]]; then
  cp "$VV_SCRIPTS/"vv-* ~/.local/bin/ 2>/dev/null || true

  # Set executable permissions
  chmod +x ~/.local/bin/vv-* 2>/dev/null || true
fi

# Install system-wide scripts
if [[ -d "$VV_CONFIGS/scripts" ]]; then
  sudo cp "$VV_CONFIGS/scripts/prime-launcher" /usr/local/bin/ 2>/dev/null || true
  sudo cp "$VV_CONFIGS/scripts/update-mirrors.sh" /usr/local/bin/ 2>/dev/null || true

  sudo chmod +x /usr/local/bin/prime-launcher 2>/dev/null || true
  sudo chmod +x /usr/local/bin/update-mirrors.sh 2>/dev/null || true
fi

# Ensure ~/.local/bin is in PATH
touch ~/.zshrc
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Install .desktop files for Noctalia launcher
show_info "$MSG_INSTALL_DESKTOP_FILES"
mkdir -p ~/.local/share/applications

if [[ -d "$VV_CONFIGS/applications" ]]; then
  cp "$VV_CONFIGS/applications/"*.desktop ~/.local/share/applications/ 2>/dev/null || true
  chmod 644 ~/.local/share/applications/vv-*.desktop 2>/dev/null || true
fi

# Update application database
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database ~/.local/share/applications 2>/dev/null || true
fi

show_success "$MSG_SCRIPTS_INSTALLED"
