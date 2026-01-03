#!/bin/bash
# VV OS Installer - Cyberpunk Edition
# Arch Linux + Hyprland + Noctalia Shell

set -eEo pipefail

# ============================================================================
# Cyberpunk Color Scheme (gum style colors)
# ============================================================================
C_TITLE=5        # Magenta for main titles
C_SUBTITLE=6     # Cyan for subtitles
C_SUCCESS=2      # Green for success
C_INFO=6         # Cyan for info
C_WARNING=3      # Yellow for warnings
C_ERROR=1        # Red for errors
C_ACCENT=5       # Magenta for accents

# Gum environment for consistent theming
export GUM_CONFIRM_PROMPT_FOREGROUND="6"
export GUM_CONFIRM_SELECTED_FOREGROUND="0"
export GUM_CONFIRM_SELECTED_BACKGROUND="5"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="7"

# ============================================================================
# Helper Functions
# ============================================================================
title() { gum style --foreground "$C_TITLE" --bold "$@"; }
subtitle() { gum style --foreground "$C_SUBTITLE" "$@"; }
success() { gum style --foreground "$C_SUCCESS" --bold "✓ $*"; }
info() { gum style --foreground "$C_INFO" "→ $*"; }
warning() { gum style --foreground "$C_WARNING" --bold "⚠ $*"; }
error() { gum style --foreground "$C_ERROR" --bold "✗ $*"; }
section() { echo ""; gum style --foreground "$C_ACCENT" --bold "━━━ $* ━━━"; echo ""; }

# ============================================================================
# Pre-flight Checks
# ============================================================================
check_arch_live() {
  if [[ ! -f /etc/arch-release ]]; then
    error "This script must be run from Arch Linux Live ISO"
    exit 1
  fi
}

check_internet() {
  info "Checking internet connection..."
  if curl -s https://archlinux.org > /dev/null 2>&1 || curl -s https://google.com > /dev/null 2>&1; then
    success "Internet connection available"
    return 0
  fi
  error "No internet connection detected!"
  echo ""
  warning "Internet is required for installation"
  echo ""

  info "$(cat <<EOF
      📡 HOW TO CONNECT TO INTERNET

      WiFi:
      1. iwctl
      2. station wlan0 scan
      3. station wlan0 get-networks
      4. station wlan0 connect "Your-WiFi-Name"
      5. exit

      Wired (Ethernet):
        • Usually connects automatically (DHCP)
        • If not: dhcpcd

      Check connection:
        • ping archlinux.org
        • ip a (check if you have an IP address)

      After connecting, run this installer again. (just type "exit" and push Enter)
EOF
)"

    echo ""
  exit 1
}

install_dependencies() {
  # Python3
  if ! command -v python3 &>/dev/null; then
    info "Installing Python3..."
    pacman -Sy --noconfirm --needed python
  fi
  # Gum
  if ! command -v gum &>/dev/null; then
    info "Installing gum..."
    pacman -Sy --noconfirm --needed gum
  fi
}

# ============================================================================
# Welcome Screen
# ============================================================================
show_welcome() {
  clear
  echo ""
  cat << "EOF"
██╗   ██╗██╗   ██╗     ██████╗ ███████╗
██║   ██║██║   ██║    ██╔═══██╗██╔════╝
██║   ██║██║   ██║    ██║   ██║███████╗
╚██╗ ██╔╝╚██╗ ██╔╝    ██║   ██║╚════██║
 ╚████╔╝  ╚████╔╝     ╚██████╔╝███████║
  ╚═══╝    ╚═══╝       ╚═════╝ ╚══════╝
EOF
  echo ""
  title "CYBERPUNK ARCH LINUX DISTRIBUTION"
  subtitle "Hyprland • Noctalia Shell • Material 3 • Gaming Ready"
  echo ""
  gum style --foreground 7 "Press ENTER to start installation..."
  read -r
}

launch_installer() {
  PY_INSTALLER="/root/vv-os/vv-python-installer.py"
  if [[ ! -f "$PY_INSTALLER" ]]; then
    error "Python installer not found at $PY_INSTALLER"
    exit 1
  fi
  python3 "$PY_INSTALLER"
}

# ============================================================================
# Base Installation Verification
# ============================================================================
verify_base_install() {
  section "STEP 3: Verifying Base Installation"
  if ! mountpoint -q /mnt; then
    error "/mnt is not a mountpoint!"
    warning "archinstall did not mount the root filesystem"
    exit 1
  fi
  if [[ ! -f /mnt/etc/fstab ]]; then
    error "/mnt/etc/fstab not found!"
    warning "Base system installation incomplete"
    exit 1
  fi
  success "Base system verified successfully"
}

# ============================================================================
# Run Post-install in chroot
# ============================================================================
run_postinstall_in_chroot() {
  section "STEP 4: Running VV OS Post-installation"

  VV_OS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  info "Copying VV OS to installed system..."
  mkdir -p /mnt/root/vv-os
  cp -r "$VV_OS_PATH"/* /mnt/root/vv-os/
  chmod +x /mnt/root/vv-os/install.sh
  success "Copied VV OS files"

  # Mount required filesystems for chroot
  info "Mounting /dev, /proc, /sys, /run for chroot..."
  mount --bind /dev /mnt/dev
  mount --bind /proc /mnt/proc
  mount --bind /sys /mnt/sys
  mount --bind /run /mnt/run

  # Run post-install
  info "Starting post-installation (this may take 20-30 minutes)..."
  if arch-chroot /mnt /root/vv-os/install.sh; then
    success "Post-installation completed successfully!"
  else
    error "Post-installation FAILED!"
    warning "You can troubleshoot by chrooting into /mnt manually"
    exit 1
  fi

  # Unmount chroot filesystems
  umount /mnt/{dev,proc,sys,run} 2>/dev/null || true
}

# ============================================================================
# Completion Screen
# ============================================================================
show_complete() {
  clear
  cat << "EOF"
██╗   ██╗██╗   ██╗     ██████╗ ███████╗
██║   ██║██║   ██║    ██╔═══██╗██╔════╝
██║   ██║██║   ██║    ██║   ██║███████╗
╚██╗ ██╔╝╚██╗ ██╔╝    ██║   ██║╚════██║
 ╚████╔╝  ╚████╔╝     ╚██████╔╝███████║
  ╚═══╝    ╚═══╝       ╚═════╝ ╚══════╝
EOF
  title "BASE INSTALLATION COMPLETE"
  subtitle "VV OS will finish setup on first boot"
  success "Base Arch Linux system installed"
  echo ""
  gum style --foreground "$C_ACCENT" "Press ENTER to reboot..."
  read -r
  reboot
}

# ============================================================================
# Main Flow
# ============================================================================
main() {
  check_arch_live
  check_internet
  install_dependencies

  show_welcome
  CHOICE=$(gum choose "Start VV Python Installer" "Exit")
  if [[ "$CHOICE" == "Start VV Python Installer" ]]; then
    launch_installer
  else
    echo "Exiting installer..."
    exit 0
  fi
  verify_base_install
  run_postinstall_in_chroot
  show_complete
}

main
