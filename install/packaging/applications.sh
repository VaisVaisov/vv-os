#!/bin/bash
# Установка приложений (опционально)

show_info "$MSG_INSTALL_ADDITIONAL_APPS"

# Категории приложений
categories=(
  "applications:$MSG_CATEGORY_APPLICATIONS"
  "development:$MSG_CATEGORY_DEVELOPMENT"
  "media:$MSG_CATEGORY_MEDIA"
  "theming:$MSG_CATEGORY_THEMING"
)

for item in "${categories[@]}"; do
  category="${item%%:*}"
  description="${item#*:}"

  if gum confirm "$MSG_CONFIRM_CATEGORY ${description}?"; then
    # Official пакеты
    official_file="$VV_PACKAGES/vv-${category}-official.txt"
    if [[ -f "$official_file" ]]; then
      mapfile -t official < <(grep -v '^#' "$official_file" | grep -v '^$')
      if [ ${#official[@]} -gt 0 ]; then
        sudo pacman -S --noconfirm --needed "${official[@]}"
      fi
    fi

    # AUR пакеты
    aur_file="$VV_PACKAGES/vv-${category}-aur.txt"
    if [[ -f "$aur_file" ]]; then
      mapfile -t aur < <(grep -v '^#' "$aur_file" | grep -v '^$')
      if [ ${#aur[@]} -gt 0 ]; then
        paru -S --noconfirm --needed "${aur[@]}"
      fi
    fi
  fi
done

show_success "$MSG_APPS_OK"
