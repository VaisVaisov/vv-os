#!/bin/bash
# Install user avatar

show_info "$MSG_SETUP_AVATAR"

# Check for .face file
if [[ -f "$VV_ASSETS/avatar/.face" ]]; then
  # Copy .face to home directory
  cp "$VV_ASSETS/avatar/.face" $VV_USER_HOME/.face

  # Create .face.icon symlink (used by some display managers)
  ln -sf $VV_USER_HOME/.face $VV_USER_HOME/.face.icon

  show_success "$MSG_AVATAR_INSTALLED"
else
  show_info "$MSG_AVATAR_NOT_FOUND"
fi
