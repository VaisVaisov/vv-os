#!/bin/bash
# Install .desktop files for applications

show_info "$MSG_SETUP_APPLICATIONS"

# Copy .desktop files to $VV_USER_HOME/.local/share/applications
mkdir -p $VV_USER_HOME/.local/share/applications

if [[ -d "$VV_CONFIGS/applications" ]]; then
  # Copy all .desktop files
  for desktop_file in "$VV_CONFIGS/applications"/*.desktop; do
    if [[ -f "$desktop_file" ]]; then
      cp "$desktop_file" $VV_USER_HOME/.local/share/applications/
      show_success "$MSG_SETUPPED_APPLICATION $(basename "$desktop_file")"
    fi
  done

  # Update application database
  if command -v update-desktop-database &>/dev/null; then
    update-desktop-database $VV_USER_HOME/.local/share/applications
  fi

  show_success "$MSG_APPLICATIONS_OK"
else
  show_info "Applications directory not found, skipping"
fi
