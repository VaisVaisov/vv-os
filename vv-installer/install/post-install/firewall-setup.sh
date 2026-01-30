#!/bin/bash
# Configure Firewall

# -------------------------------------------------------------------
# Define services with descriptions
# -------------------------------------------------------------------
services=(
  "SSH:22/tcp:Allow remote SSH access"
  "HTTPS:443/tcp:Allow secure web traffic"
  "WireGuard:51820/udp:Allow WireGuard VPN"
  "AmneziaWG:55424/udp:Allow AmneziaWG VPN"
  "Shadowsocks:8388/tcp+udp:Allow Shadowsocks proxy"
  "MTProto:443/tcp:Allow MTProto proxy (Telegram)"
  "Torrents:49152-65535/tcp+udp:Allow torrent traffic"
  "VLESS:443/tcp:Allow VLESS proxy (TLS)"
)

# -------------------------------------------------------------------
# Function to run selection and confirmation
# -------------------------------------------------------------------
select_services() {
  clear
  show_header "$MSG_FIREWALL_HEADER"
  show_info "$MSG_FIREWALL_INFO_SELECT"

  # Build choice strings with descriptions
  choices=()
  for item in "${services[@]}"; do
    IFS=":" read -r name port desc <<< "$item"
    choices+=("$name ($port) — $desc")
  done

  selected=$(gum choose --no-limit "${choices[@]}")

  if [ -z "$selected" ]; then
    show_info "$MSG_FIREWALL_INFO_SELECTED None. All incoming traffic will be blocked."
  else
    show_info "$MSG_FIREWALL_INFO_SELECTED"
    echo "$selected"
  fi

  # gum confirm returns exit code, not text
  if ! gum confirm "$MSG_FIREWALL_CONFIRM" --default=false; then
    show_info "$MSG_FIREWALL_RESTART_SELECTION"
    select_services
  fi
}

# -------------------------------------------------------------------
# Custom port
# -------------------------------------------------------------------
custom_port_rule() {
  # gum confirm returns exit code, not text
  if gum confirm "$MSG_FIREWALL_CUSTOM_ASK" --default=false; then
    port=$(gum input --placeholder "$MSG_FIREWALL_CUSTOM_PORT")
    protocol=$(gum input --placeholder "$MSG_FIREWALL_CUSTOM_PROTOCOL")
    desc=$(gum input --placeholder "$MSG_FIREWALL_CUSTOM_DESC")
    CUSTOM_RULE="$port/$protocol:$desc"
  fi
}

# -------------------------------------------------------------------
# Apply rules based on selection
# -------------------------------------------------------------------
apply_rules() {
  show_info "$MSG_FIREWALL_RESET"
  sudo ufw --force reset

  show_info "$MSG_FIREWALL_DEFAULT_POLICIES"
  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  # Apply standard rules
  for choice in $selected; do
    case "$choice" in
      SSH*)
        show_info "$MSG_FIREWALL_ALLOW_SSH"
        sudo ufw allow 22/tcp
        ;;
      HTTPS*)
        show_info "$MSG_FIREWALL_ALLOW_HTTPS"
        sudo ufw allow 443/tcp
        ;;
      WireGuard*)
        show_info "$MSG_FIREWALL_ALLOW_WIREGUARD"
        sudo ufw allow 51820/udp
        ;;
      AmneziaWG*)
        show_info "$MSG_FIREWALL_ALLOW_AMNEZIAWG"
        sudo ufw allow 55424/udp
        ;;
      Shadowsocks*)
        show_info "$MSG_FIREWALL_ALLOW_SHADOWSOCKS"
        sudo ufw allow 8388/tcp
        sudo ufw allow 8388/udp
        ;;
      MTProto*)
        show_info "$MSG_FIREWALL_ALLOW_MTPROTO"
        sudo ufw allow 443/tcp
        ;;
      Torrents*)
        show_info "$MSG_FIREWALL_ALLOW_TORRENTS"
        sudo ufw allow 49152:65535/tcp
        sudo ufw allow 49152:65535/udp
        ;;
      VLESS*)
        show_info "$MSG_FIREWALL_ALLOW_VLESS"
        sudo ufw allow 443/tcp
        ;;
    esac
  done

  # Apply custom port rule if any
  if [ -n "$CUSTOM_RULE" ]; then
    IFS=":" read -r port_proto desc <<< "$CUSTOM_RULE"
    show_info "$MSG_FIREWALL_CUSTOM_APPLY $desc ($port_proto)"
    sudo ufw allow "$port_proto"
  fi

  show_info "$MSG_FIREWALL_ENABLE"
  sudo ufw --force enable

  # Enable UFW systemd service
  show_info "$MSG_FIREWALL_ENABLE_SERVICE"
  if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
    sudo systemctl enable ufw.service
  else
    systemctl enable ufw.service
  fi

  # Auto-detect and configure Happ VPN if installed
  if command -v happ &>/dev/null; then
    show_info "$MSG_FIREWALL_HAPP_DETECTED"
    sudo ufw allow in on tun0
    sudo ufw allow out on tun0
    show_success "$MSG_FIREWALL_HAPP_CONFIGURED"
  fi

  # Configure xhost for gufw GUI on Wayland (Hyprland)
  show_info "$MSG_FIREWALL_CONFIGURE_XHOST"
  HYPR_AUTOSTART="$VV_USER_HOME/.config/hypr/autostart.conf"

  if [[ -f "$HYPR_AUTOSTART" ]]; then
    # Check if xhost already configured
    if ! grep -q "xhost +SI:localuser:root" "$HYPR_AUTOSTART"; then
      echo "" >> "$HYPR_AUTOSTART"
      echo "# X server access for root apps (gufw, etc.) on Wayland" >> "$HYPR_AUTOSTART"
      echo "exec-once = xhost +SI:localuser:\$(id -un)" >> "$HYPR_AUTOSTART"
      echo "exec-once = xhost +SI:localuser:root" >> "$HYPR_AUTOSTART"
      chown "$VV_USER:$VV_USER" "$HYPR_AUTOSTART"
      show_success "$MSG_FIREWALL_XHOST_CONFIGURED"
    else
      show_info "$MSG_FIREWALL_XHOST_ALREADY"
    fi
  else
    show_warning "$MSG_FIREWALL_HYPR_NOT_FOUND"
  fi

  show_success "$MSG_FIREWALL_COMPLETE"
  sudo ufw status verbose
}

# -------------------------------------------------------------------
# Main
# -------------------------------------------------------------------
main() {
  select_services
  custom_port_rule
  apply_rules
}

main
