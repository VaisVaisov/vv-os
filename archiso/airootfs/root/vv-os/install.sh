#!/bin/bash
# VV OS Installer - Main installation script
# Based on Omarchy architecture

set -eEo pipefail

# Determine the VV OS root directory
VV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Export essential paths
export VV_ROOT
export VV_INSTALL="$VV_ROOT/install"
export VV_PACKAGES="$VV_ROOT/packages"
export VV_CONFIGS="$VV_ROOT/configs"
export VV_SCRIPTS="$VV_ROOT/scripts"
export VV_ASSETS="$VV_ROOT/assets"
export VV_LANG="$VV_ROOT/lang"
export VV_INSTALL_LOG_FILE="/var/log/vv_install_$(date '+%Y%m%d_%H%M%S').log"

# Detect chroot environment
if [ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ] 2>/dev/null; then
  export VV_CHROOT_INSTALL=1
fi

# Add user bin to PATH (for custom scripts)
export PATH="$HOME/.local/bin:$PATH"

# Determine actual user (not root)
if [[ "$EUID" -eq 0 ]]; then
  # Running as root - get all non-system users
  mapfile -t VV_USERS < <(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

  if [ ${#VV_USERS[@]} -eq 0 ]; then
    # No users found - create one interactively
    echo "No regular users found. Let's create one!"
    echo ""

    VV_NEW_USER=$(gum input --placeholder "Username")
    if [ -z "$VV_NEW_USER" ]; then
      echo "ERROR: Username cannot be empty"
      exit 1
    fi

    VV_NEW_PASS=$(gum input --password --placeholder "Password for $VV_NEW_USER")
    if [ -z "$VV_NEW_PASS" ]; then
      echo "ERROR: Password cannot be empty"
      exit 1
    fi

    echo "Creating user: $VV_NEW_USER..."

    # Create user with home directory, add to wheel group, set zsh as shell
    useradd -m -G wheel -s /bin/zsh "$VV_NEW_USER"

    # Set password
    echo "$VV_NEW_USER:$VV_NEW_PASS" | chpasswd

    # Enable sudo for user
    echo "$VV_NEW_USER ALL=(ALL) ALL" > /etc/sudoers.d/10-$VV_NEW_USER
    chmod 440 /etc/sudoers.d/10-$VV_NEW_USER

    echo "User $VV_NEW_USER created successfully!"
    echo ""

    VV_USERS=("$VV_NEW_USER")
  fi

  if [ ${#VV_USERS[@]} -eq 1 ]; then
    # Only one user - use it automatically
    VV_USER="${VV_USERS[0]}"
    echo "Installing VV OS for user: $VV_USER"
  else
    # Multiple users - allow selecting multiple (like locale selection)
    echo "Multiple users detected. Select users for VV OS installation:"
    selected=$(gum choose --no-limit "${VV_USERS[@]}")

    if [ -z "$selected" ]; then
      echo "ERROR: No users selected"
      exit 1
    fi

    # For now, use first selected user (multi-user install requires more complex logic)
    VV_USER=$(echo "$selected" | head -n1)
    echo "Selected user: $VV_USER"
    echo "Note: Multi-user installation will be implemented in future versions"
  fi

  VV_USER_HOME="/home/$VV_USER"
else
  VV_USER="$USER"
  VV_USER_HOME="$HOME"
fi

export VV_USER
export VV_USER_HOME

# Load English language file (only supported language)
source "$VV_LANG/en.sh"

# Welcome message
echo "${MSG_WELCOME:-Welcome to VV OS Installer}"
echo "${MSG_STARTING:-Starting installation...}"
echo ""

# Load installation modules
source "$VV_INSTALL/helpers/all.sh"
source "$VV_INSTALL/preflight/all.sh"
source "$VV_INSTALL/packaging/all.sh"
source "$VV_INSTALL/config/all.sh"
source "$VV_INSTALL/login/all.sh"
source "$VV_INSTALL/post-install/all.sh"
