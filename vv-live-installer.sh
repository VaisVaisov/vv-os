#!/bin/bash
# VV OS Installer - Cyberpunk Edition
# Arch Linux + Hyprland + Noctalia Shell

set -eEo pipefail

# ============================================================================
# Terminal Size Detection (Dynamic Centering)
# ============================================================================

# Get terminal dimensions
if [ -e /dev/tty ]; then
  TERM_SIZE=$(stty size 2>/dev/null </dev/tty)
  TERM_HEIGHT=$(echo "$TERM_SIZE" | cut -d' ' -f1)
  TERM_WIDTH=$(echo "$TERM_SIZE" | cut -d' ' -f2)
else
  TERM_WIDTH=80
  TERM_HEIGHT=24
fi

# Calculate logo width (max line length in ASCII art)
LOGO_WIDTH=62  # VV OS ASCII logo width
PADDING_LEFT=$((($TERM_WIDTH - $LOGO_WIDTH) / 2))
PADDING_LEFT=$((PADDING_LEFT > 0 ? PADDING_LEFT : 0))

# Universal padding for all gum commands (top right bottom left)
export PADDING="0 0 0 $PADDING_LEFT"
export GUM_CHOOSE_PADDING="$PADDING"
export GUM_CONFIRM_PADDING="$PADDING"
export GUM_INPUT_PADDING="$PADDING"
export GUM_STYLE_PADDING="$PADDING"

# ============================================================================
# Cyberpunk Color Scheme (gum style colors)
# ============================================================================
# 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white

C_TITLE=5        # Magenta for main titles
C_SUBTITLE=6     # Cyan for subtitles
C_SUCCESS=2      # Green for success
C_INFO=6         # Cyan for info
C_WARNING=3      # Yellow for warnings
C_ERROR=1        # Red for errors
C_ACCENT=5       # Magenta for accents

# Gum environment for consistent theming
export GUM_CONFIRM_PROMPT_FOREGROUND="6"       # Cyan for prompts
export GUM_CONFIRM_SELECTED_FOREGROUND="0"     # Black on selected
export GUM_CONFIRM_SELECTED_BACKGROUND="5"     # Magenta background
export GUM_CONFIRM_UNSELECTED_FOREGROUND="7"   # White for unselected

# ============================================================================
# Helper Functions
# ============================================================================

title() {
  gum style --foreground "$C_TITLE" --bold --align center "$@"
}

subtitle() {
  gum style --foreground "$C_SUBTITLE" --align center "$@"
}

success() {
  gum style --foreground "$C_SUCCESS" --bold "✓ $*"
}

info() {
  gum style --foreground "$C_INFO" "→ $*"
}

warning() {
  gum style --foreground "$C_WARNING" --bold "⚠ $*"
}

error() {
  gum style --foreground "$C_ERROR" --bold "✗ $*"
}

section() {
  echo ""
  gum style --foreground "$C_ACCENT" --bold "━━━ $* ━━━"
  echo ""
}

centered_text() {
  gum style --align center "$@"
}

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

  # Check via HTTPS (more reliable than ping)
  if curl -s https://archlinux.org > /dev/null 2>&1 || \
     curl -s https://google.com > /dev/null 2>&1; then
    success "Internet connection available"
    return 0
  fi

  echo ""
  error "No internet connection detected!"
  echo ""
  warning "Internet is required for installation"
  echo ""
  centered_text "How to connect to internet:"
  echo ""
  echo "  WiFi (iwctl):"
  echo "    iwctl"
  echo "    station wlan0 scan"
  echo "    station wlan0 get-networks"
  echo "    station wlan0 connect \"SSID\""
  echo ""
  echo "  Ethernet (automatic via dhcpcd)"
  echo ""
  echo "  After connecting, restart the installer:"
  echo "    exit"
  echo ""
  echo "  (or manually: cd /root/vv-os && ./vv-live-installer.sh)"
  echo ""
  exit 1
}

install_gum() {
  if ! command -v gum &>/dev/null; then
    echo "Installing gum..."
    pacman -Sy --noconfirm --needed gum || {
      error "Failed to install gum. Check your internet connection."
      exit 1
    }
  fi
}

# ============================================================================
# Welcome Screen
# ============================================================================

show_welcome() {
  clear
  echo ""
  echo ""

  # ASCII Art (centered)
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
  echo ""
  subtitle "Hyprland • Noctalia Shell • Material 3 • Gaming Ready"
  echo ""
  echo ""

  gum style --foreground 7 --align center "Press ENTER to start installation..."
  read -r
}

# ============================================================================
# Partitioning Mode Selection
# ============================================================================

select_partitioning_mode() {
  section "STEP 1: Disk Partitioning Mode"

  PARTITION_MODE=$(gum choose \
    "Separate /home partition (recommended)" \
    "Everything in root (minimalist)" \
    "Dual-boot with Windows" \
    "Manual partitioning")

  echo ""
  info "Selected: $PARTITION_MODE"
  echo ""
}

# ============================================================================
# Generate archinstall Profile
# ============================================================================

generate_archinstall_profile() {
  local mode="$1"
  local profile_path="/tmp/vv-archinstall-profile.json"

  cat > "$profile_path" <<EOF
{
  "version": "2.8.0",
  "bootloader": "grub",
  "kernels": ["linux-zen"],
  "network_config": {"type": "nm"},
  "ntp": true,
  "packages": [
    "base-devel",
    "git",
    "vim",
    "wget",
    "curl",
    "openssh",
    "networkmanager",
    "pipewire",
    "pipewire-pulse",
    "pipewire-alsa",
    "pipewire-jack",
    "wireplumber",
    "alsa-utils",
    "sof-firmware",
    "gum",
    "zram-generator"
  ],
  "parallel downloads": 5,
  "profile_config": {
    "profile": {
      "details": [],
      "main": "minimal"
    }
  },
  "script": "guided",
  "swap": false
EOF

  # Add disk_config hint
  case "$mode" in
    "Separate /home partition (recommended)")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Auto partitioning with separate /home will be configured interactively"
EOF
      ;;
    "Everything in root (minimalist)")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Auto partitioning (everything in root) will be configured interactively"
EOF
      ;;
    "Dual-boot with Windows")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Dual-boot partitioning will be configured interactively (use existing Windows EFI)"
EOF
      ;;
    "Manual partitioning")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Manual partitioning via archinstall"
EOF
      ;;
  esac

  echo "}" >> "$profile_path"
  echo "$profile_path"
}

# ============================================================================
# Run archinstall
# ============================================================================

run_archinstall() {
  local profile="$1"
  local mode="$2"

  section "STEP 2: Base System Installation"

  # Show instructions
  case "$mode" in
    "Separate /home partition (recommended)")
      subtitle "Partitioning Instructions:"
      echo ""
      echo "  1. Select disk for installation"
      echo "  2. Create partitions:"
      echo "     • EFI partition: 512MB (fat32)"
      echo "     • root partition: 50GB (ext4)"
      echo "     • home partition: remaining space (ext4)"
      ;;
    "Everything in root (minimalist)")
      subtitle "Partitioning Instructions:"
      echo ""
      echo "  1. Select disk for installation"
      echo "  2. Create partitions:"
      echo "     • EFI partition: 512MB (fat32)"
      echo "     • root partition: all remaining space (ext4)"
      ;;
    "Dual-boot with Windows)")
      subtitle "Dual-boot Instructions:"
      echo ""
      warning "DO NOT create a new EFI partition!"
      echo ""
      echo "  1. Use existing Windows EFI partition"
      echo "  2. Create only:"
      echo "     • root partition: 50GB or custom (ext4)"
      echo "     • home partition: remaining space (ext4, optional)"
      echo "  3. GRUB will automatically detect Windows via os-prober"
      ;;
    "Manual partitioning")
      subtitle "Use manual partitioning in archinstall"
      ;;
  esac

  echo ""
  gum confirm "Ready to proceed with archinstall?" || {
    warning "Installation cancelled by user"
    exit 0
  }

  info "Initializing pacman keyring..."
  pacman-key --init
  pacman-key --populate archlinux

  echo ""
  info "Launching archinstall..."
  echo ""

  # Run archinstall
  if archinstall --config "$profile"; then
    return 0
  else
    echo ""
    error "archinstall failed!"
    echo ""
    warning "Check /var/log/archinstall/install.log for details"
    warning "You can run archinstall --debug for verbose output"
    echo ""
    exit 1
  fi
}

# ============================================================================
# Verify Base Installation
# ============================================================================

verify_base_install() {
  section "STEP 3: Verifying Base Installation"

  # Check if /mnt is a mountpoint
  if ! mountpoint -q /mnt; then
    error "/mnt is not a mountpoint!"
    echo ""
    warning "archinstall did not mount the root filesystem"
    warning "This usually happens when:"
    echo "  • Partitioning was cancelled"
    echo "  • Installation failed during package installation"
    echo "  • No disk was selected"
    echo ""
    error "Cannot proceed with VV OS installation"
    echo ""
    exit 1
  fi

  # Check if basic files exist
  if [[ ! -f /mnt/etc/fstab ]]; then
    error "/mnt/etc/fstab not found!"
    echo ""
    warning "Base system installation incomplete"
    echo ""
    exit 1
  fi

  success "Base system verified successfully"
  echo ""
}

# ============================================================================
# Install VV OS in chroot
# ============================================================================

install_vv_os_chroot() {
  section "STEP 4: Installing VV OS Components"

  subtitle "Hyprland • Noctalia Shell • Gaming Stack • Cyberpunk Theming"
  echo ""

  # Get VV OS path
  VV_OS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Copy VV OS to /mnt/tmp/
  info "Copying VV OS to installed system..."
  mkdir -p /mnt/tmp/vv-os
  cp -r "$VV_OS_PATH"/* /mnt/tmp/vv-os/
  success "VV OS files copied"
  echo ""

  info "Installing VV OS in chroot environment..."
  warning "This will take 20-30 minutes..."
  echo ""

  # Run install.sh in chroot
  if arch-chroot /mnt /bin/bash <<'CHROOT_SCRIPT'
export VV_CHROOT_INSTALL=true
cd /tmp/vv-os
bash install.sh
CHROOT_SCRIPT
  then
    # Cleanup
    rm -rf /mnt/tmp/vv-os

    echo ""
    success "VV OS installed successfully!"
    echo ""
  else
    error "VV OS installation failed in chroot!"
    echo ""
    warning "Check logs for details"
    echo ""
    exit 1
  fi
}

# ============================================================================
# Installation Complete
# ============================================================================

show_complete() {
  clear
  echo ""
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
  title "INSTALLATION COMPLETE"
  echo ""
  subtitle "Your cyberpunk system is ready!"
  echo ""
  echo ""

  success "VV OS has been successfully installed"
  echo ""

  centered_text "Next steps:"
  echo ""
  echo "  1. Reboot your system"
  echo "  2. Select 'Hyprland' in SDDM login screen"
  echo "  3. Enjoy your cyberpunk Arch Linux!"
  echo ""
  echo ""

  gum style --foreground "$C_ACCENT" --align center "Press ENTER to reboot..."
  read -r

  reboot
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
  # Pre-flight checks
  check_arch_live
  install_gum
  check_internet

  # Welcome screen
  show_welcome

  # Partitioning mode selection
  select_partitioning_mode

  # Generate archinstall profile
  PROFILE=$(generate_archinstall_profile "$PARTITION_MODE")

  # Run archinstall
  run_archinstall "$PROFILE" "$PARTITION_MODE"

  # Verify base installation
  echo ""
  success "Base Arch installation complete!"
  echo ""

  verify_base_install

  # Install VV OS components
  install_vv_os_chroot

  # Show completion screen
  show_complete
}

# Run installer
main
