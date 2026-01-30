#!/bin/bash
# Install optional applications with granular selection

show_info "$MSG_INSTALL_ADDITIONAL_APPS"

categories=(
  "applications:$MSG_CATEGORY_APPLICATIONS"
  "development:$MSG_CATEGORY_DEVELOPMENT"
  "media:$MSG_CATEGORY_MEDIA"
  "theming:$MSG_CATEGORY_THEMING"
)

# Update package database (on all repositories)
sudo pacman -Sy --noconfirm

# -------------------------------------------------------------------
# Process each category
# -------------------------------------------------------------------
for item in "${categories[@]}"; do
  category="${item%%:*}"
  description="${item#*:}"

  # Read package lists
  official_file="$VV_PACKAGES/vv-${category}-official.txt"
  aur_file="$VV_PACKAGES/vv-${category}-aur.txt"

  mapfile -t official < <(grep -v '^#' "$official_file" 2>/dev/null | grep -v '^$')
  mapfile -t aur < <(grep -v '^#' "$aur_file" 2>/dev/null | grep -v '^$')

  # Skip if both files are empty
  if [ ${#official[@]} -eq 0 ] && [ ${#aur[@]} -eq 0 ]; then
    continue
  fi

  # -------------------------------------------------------------------
  # Build choices for gum
  # -------------------------------------------------------------------
  echo ""
  show_info "$MSG_APPS_SELECT_PACKAGES ${description}:"
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
    show_info "$MSG_APPS_SKIP_CATEGORY ${description}"
    continue
  fi

  # Install packages based on selection
  if $install_all; then
    # Install everything
    show_info "$MSG_APPS_INSTALL_ALL ${description}..."

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
    show_info "$MSG_APPS_INSTALL_SELECTED ${description}..."

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
done

cleanup_builduser
show_success "$MSG_APPS_OK"
