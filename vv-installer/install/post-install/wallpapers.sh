#!/bin/bash
# Install wallpapers

show_info "$MSG_INSTALL_WALLPAPERS"

# Create wallpapers directory
mkdir -p ~/Pictures/Wallpapers

# Check for wallpapers archive
if [[ -f "$VV_ASSETS/wallpapers/wallpapers.zip" ]]; then
  show_info "$MSG_EXTRACT_WALLPAPERS"
  unzip -o "$VV_ASSETS/wallpapers/wallpapers.zip" -d ~/Pictures/Wallpapers/
  show_success "$MSG_WALLPAPERS_EXTRACTED"
# If no archive, copy files directly
elif [[ -d "$VV_ASSETS/wallpapers" ]]; then
  show_info "$MSG_COPY_WALLPAPERS"
  cp "$VV_ASSETS/wallpapers/"*.{png,jpg,jpeg} ~/Pictures/Wallpapers/ 2>/dev/null || true
  show_success "$MSG_WALLPAPERS_COPIED"
else
  show_info "$MSG_WALLPAPERS_NOT_FOUND"
fi

show_success "$MSG_WALLPAPERS_OK"
