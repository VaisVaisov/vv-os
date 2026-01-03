#!/bin/bash
# Install optional applications

show_info "$MSG_INSTALL_ADDITIONAL_APPS"

categories=(
  "applications:$MSG_CATEGORY_APPLICATIONS"
  "development:$MSG_CATEGORY_DEVELOPMENT"
  "media:$MSG_CATEGORY_MEDIA"
  "theming:$MSG_CATEGORY_THEMING"
)

# Update package database (on all repositories)
sudo pacman -Sy --noconfirm

for item in "${categories[@]}"; do
  category="${item%%:*}"
  description="${item#*:}"

  # Show package lists for this category
  if [[ -f "$VV_PACKAGES/vv-${category}-official.txt" ]]; then
    echo ""
    show_info "Official ${category} packages:"
    grep -v '^#' "$VV_PACKAGES/vv-${category}-official.txt" | grep -v '^$' | sed 's/^/  • /'
    echo ""
  fi

  if [[ -f "$VV_PACKAGES/vv-${category}-aur.txt" ]]; then
    echo ""
    show_info "AUR ${category} packages:"
    grep -v '^#' "$VV_PACKAGES/vv-${category}-aur.txt" | grep -v '^$' | sed 's/^/  • /'
    echo ""
  fi

  if gum confirm "$MSG_CONFIRM_CATEGORY ${description}?"; then
    # Official packages
    official_file="$VV_PACKAGES/vv-${category}-official.txt"
    if [[ -f "$official_file" ]]; then
      mapfile -t official < <(grep -v '^#' "$official_file" | grep -v '^$')
      if [ ${#official[@]} -gt 0 ]; then
        sudo pacman -S --noconfirm --needed "${official[@]}"
      fi
    fi

    # AUR packages
    aur_file="$VV_PACKAGES/vv-${category}-aur.txt"
    if [[ -f "$aur_file" ]]; then
      mapfile -t aur < <(grep -v '^#' "$aur_file" | grep -v '^$')
      for pkg in "${aur[@]}"; do
        install_aur_package "$pkg"
      done
    fi
  fi
done

cleanup_builduser
show_success "$MSG_APPS_OK"
