#!/bin/bash
# Install gaming packages (optional with granular selection)

show_info "$MSG_INSTALL_GAMING"

# -------------------------------------------------------------------
# Read package lists
# -------------------------------------------------------------------
mapfile -t official < <(grep -v '^#' "$VV_PACKAGES/vv-gaming-official.txt" | grep -v '^$')
mapfile -t aur < <(grep -v '^#' "$VV_PACKAGES/vv-gaming-aur.txt" | grep -v '^$')

# -------------------------------------------------------------------
# Build choices for gum
# -------------------------------------------------------------------
show_info "$MSG_GAMING_SELECT_PACKAGES"
echo ""

choices=(
  "[Install all packages]"
  "[Skip this category]"
)

# Add official packages
for pkg in "${official[@]}"; do
  choices+=("$pkg")
done

# Add AUR packages with (AUR) marker
for pkg in "${aur[@]}"; do
  choices+=("$pkg (AUR)")
done

# Run gum selection
selected=$(gum choose --no-limit --height 20 "${choices[@]}")

# -------------------------------------------------------------------
# Process selection
# -------------------------------------------------------------------
# Check if user skipped
skip=false
install_all=false
for choice in $selected; do
  if [[ "$choice" == "[Skip" ]]; then
    skip=true
    break
  fi
  if [[ "$choice" == "[Install" ]]; then
    install_all=true
  fi
done

if $skip; then
  show_info "$MSG_SKIP_GAMING"
  return 0
fi

# Update package database (ensure multilib packages are available)
sudo pacman -Sy --noconfirm

# Install packages based on selection
if $install_all; then
  # Install everything
  show_info "$MSG_GAMING_INSTALL_ALL"

  # Official packages
  if [ ${#official[@]} -gt 0 ]; then
    sudo pacman -S --noconfirm --needed "${official[@]}"
  fi

  # AUR packages
  for pkg in "${aur[@]}"; do
    install_aur_package "$pkg"
  done
else
  # Install only selected packages
  show_info "$MSG_GAMING_INSTALL_SELECTED"

  selected_official=()
  selected_aur=()

  # Parse selection
  for choice in $selected; do
    # Skip special options
    if [[ "$choice" == "["* ]]; then
      continue
    fi

    # Check if it's AUR package (ends with "(AUR)")
    if [[ "$choice" == *"(AUR)" ]]; then
      # Remove "(AUR)" suffix to get package name
      pkg="${choice% (AUR)}"
      selected_aur+=("$pkg")
    else
      # Official package
      selected_official+=("$choice")
    fi
  done

  # Install official packages
  if [ ${#selected_official[@]} -gt 0 ]; then
    sudo pacman -S --noconfirm --needed "${selected_official[@]}"
  fi

  # Install AUR packages
  for pkg in "${selected_aur[@]}"; do
    install_aur_package "$pkg"
  done
fi

cleanup_builduser
show_success "$MSG_GAMING_OK"
