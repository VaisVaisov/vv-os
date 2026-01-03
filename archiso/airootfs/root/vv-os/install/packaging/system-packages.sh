#!/bin/bash
# Install system-level packages grouped by category (audio, network, utilities, etc.)

show_info "$MSG_INSTALL_SYSTEM"

# Define package categories to install sequentially
categories=(
  "audio"
  "network"
  "system-utilities"
  "terminal"
  "file-manager"
)



for category in "${categories[@]}"; do
  file="$VV_PACKAGES/vv-${category}.txt"

  # Install packages from the category file if it exists
  if [[ -f "$file" ]]; then
    mapfile -t packages < <(grep -v '^#' "$file" | grep -v '^$')
    if [ ${#packages[@]} -gt 0 ]; then
      show_info "$MSG_INSTALLING_CATEGORY ${category}..."
      sudo pacman -S --noconfirm --needed "${packages[@]}"
    fi
  fi
done

show_success "$MSG_SYSTEM_OK"
