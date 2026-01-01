#!/bin/bash
# Configure GRUB and CyberGRUB theme

show_info "$MSG_SETUP_GRUB"

# Copy GRUB config
if [[ -f "$VV_CONFIGS/boot/grub" ]]; then
  sudo cp "$VV_CONFIGS/boot/grub" /etc/default/grub
  show_success "$MSG_GRUB_CONFIG_COPIED"
fi

# Install CyberGRUB-2077 via official installer
show_info "$MSG_INSTALL_CYBERGRUB"

# Clone to persistent location for future updates
CYBERGRUB_DIR="$HOME/.local/share/CyberGRUB-2077"

if [[ ! -d "$CYBERGRUB_DIR" ]]; then
  if git clone https://github.com/adnksharp/CyberGRUB-2077 "$CYBERGRUB_DIR" &>/dev/null; then
    show_success "$MSG_CYBERGRUB_CLONED"
  else
    show_info "⚠️  $MSG_CYBERGRUB_CLONE_FAIL"

    # Fallback: manually copy theme
    if [[ -d "$VV_CONFIGS/themes/grub/CyberGRUB-2077" ]]; then
      sudo mkdir -p /boot/grub/themes
      sudo cp -r "$VV_CONFIGS/themes/grub/CyberGRUB-2077" /boot/grub/themes/

      if ! grep -q "GRUB_THEME=" /etc/default/grub; then
        echo 'GRUB_THEME="/boot/grub/themes/CyberGRUB-2077/theme.txt"' | sudo tee -a /etc/default/grub >/dev/null
      fi

      sudo grub-mkconfig -o /boot/grub/grub.cfg
      show_success "$MSG_CYBERGRUB_MANUAL"
      return
    else
      show_info "⚠️  $MSG_CYBERGRUB_NOT_FOUND"
      return
    fi
  fi
fi

cd "$CYBERGRUB_DIR"

# Parse available logos from img/logos/
show_header "$MSG_CHOOSE_LOGO_CATEGORY"
echo ""

if [[ -d "img/logos" ]]; then
  mapfile -t all_logos < <(ls img/logos/*.png 2>/dev/null | xargs -n1 basename | sed 's/\.png$//' | sort)

  # Predefined logo categories
  cyberpunk_logos=("samurai" "arasaka" "militech" "trauma-team" "netwatch" "biotechnica" "kang-tao" "edgerunners")
  distro_logos=("arch" "debian" "ubuntu" "fedora" "manjaro" "endeavouros" "cachyos")

  # Let user choose category
  if command -v gum &>/dev/null; then
    echo "$MSG_CHOOSE_LOGO_CATEGORY"
    LOGO_CATEGORY=$(gum choose "$MSG_LOGO_CYBERPUNK" "$MSG_LOGO_DISTROS" "$MSG_LOGO_ALL" "$MSG_LOGO_DEFAULT")
    echo ""

    case "$LOGO_CATEGORY" in
      "$MSG_LOGO_CYBERPUNK")
        SELECTED_LOGO=$(printf '%s\n' "${cyberpunk_logos[@]}" | gum choose --header "$MSG_CHOOSE_LOGO_CATEGORY")
        ;;
      "$MSG_LOGO_DISTROS")
        SELECTED_LOGO=$(printf '%s\n' "${distro_logos[@]}" | gum choose --header "$MSG_CHOOSE_LOGO_CATEGORY")
        ;;
      "$MSG_LOGO_ALL")
        SELECTED_LOGO=$(printf '%s\n' "${all_logos[@]}" | gum choose --header "$MSG_CHOOSE_LOGO_CATEGORY" --height 20)
        ;;
      *)
        SELECTED_LOGO="samurai"
        ;;
    esac

    echo ""
    show_success "$MSG_LOGO_SELECTED: $SELECTED_LOGO"
  else
    # Fallback if gum is not available
    SELECTED_LOGO="samurai"
    show_info "$MSG_CYBERGRUB_DEFAULT_LOGO: samurai"
  fi
else
  SELECTED_LOGO="samurai"
  show_info "$MSG_CYBERGRUB_DEFAULT_LOGO: samurai"
fi

# Run official installer with selected logo
# The script performs git pull --rebase before installation
INSTALL_CMD="sudo $SHELL ./install.sh -L $SELECTED_LOGO"

if eval "$INSTALL_CMD"; then
  show_success "$MSG_CYBERGRUB_OK (logo: $SELECTED_LOGO)"

  # Save selected logo for future updates
  mkdir -p ~/.config/vv-os
  echo "$SELECTED_LOGO" > ~/.config/vv-os/cybergrub-logo.txt
else
  show_info "⚠️  $MSG_CYBERGRUB_ERROR"
fi

cd - >/dev/null

show_success "$MSG_GRUB_OK"
