#!/bin/bash
# Install wallpapers

show_info "$MSG_INSTALL_WALLPAPERS"

# Create wallpapers directory
mkdir -p $VV_USER_HOME/Pictures/Wallpapers

# If no archive, copy files directly
if [[ -d "$VV_ASSETS/wallpapers" ]]; then
  show_info "$MSG_COPY_WALLPAPERS"
  cp "$VV_ASSETS/wallpapers/"*.{png,jpg,jpeg} $VV_USER_HOME/Pictures/Wallpapers/ 2>/dev/null || true
  show_success "$MSG_WALLPAPERS_COPIED"
else
  show_info "$MSG_WALLPAPERS_NOT_FOUND"
fi

# Fix ownership (Pictures directory and all subdirectories)
chown -R "$VV_USER:$VV_USER" $VV_USER_HOME/Pictures

show_success "$MSG_WALLPAPERS_OK"
