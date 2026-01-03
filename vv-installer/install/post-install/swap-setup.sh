#!/bin/bash
# Configure zram + swapfile with dynamic calculation

show_info "$MSG_SETUP_SWAP"

# In chroot environment, only configure settings; swapfile will be created on boot
if [[ -n "${VV_CHROOT_INSTALL:-}" ]]; then
  show_info "$MSG_CHROOT_MODE"
fi

# Get RAM amount in GB
RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
if [[ "$RAM_GB" -eq 0 ]]; then
  # In chroot, RAM may not be detected; use 16GB as default
  RAM_GB=16
fi

# Dynamic swapfile calculation
if [ "$RAM_GB" -lt 8 ]; then
  SWAPFILE_SIZE="${RAM_GB}G"
elif [ "$RAM_GB" -le 16 ]; then
  SWAPFILE_SIZE="$((RAM_GB / 2))G"
else
  # For systems with 16+ GB RAM - interactive selection
  show_info "$MSG_RAM_DETECTED ${RAM_GB}GB RAM"

  SWAP_CHOICE=$(gum choose --header "$MSG_CHOOSE_SWAPFILE_SIZE" \
    "4GB ($MSG_SWAPFILE_MIN)" \
    "8GB ($MSG_SWAPFILE_RECOMMENDED)" \
    "$MSG_SWAPFILE_CUSTOM")

  case "$SWAP_CHOICE" in
    "4GB ($MSG_SWAPFILE_MIN)")
      SWAPFILE_SIZE="4G"
      ;;
    "8GB ($MSG_SWAPFILE_RECOMMENDED)")
      SWAPFILE_SIZE="8G"
      ;;
    "$MSG_SWAPFILE_CUSTOM")
      CUSTOM_SIZE=$(gum input --placeholder "$MSG_ENTER_SIZE")
      SWAPFILE_SIZE="${CUSTOM_SIZE}G"
      ;;
  esac
fi

show_info "RAM: ${RAM_GB}GB, swapfile: ${SWAPFILE_SIZE}"

# Install zram-generator (if not already installed)
if ! pacman -Q zram-generator &>/dev/null; then
  show_info "$MSG_INSTALL_ZRAM"
  sudo pacman -S --noconfirm --needed zram-generator
fi

# Create zram-generator config
show_info "$MSG_SETUP_ZRAM"
sudo tee /etc/systemd/zram-generator.conf >/dev/null <<EOF
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

# Check if swapfile exists and create if needed
if [[ ! -f /swapfile ]] && ! grep -q '/swapfile' /etc/fstab 2>/dev/null; then
  # Add swapfile to fstab (will be created on first boot via systemd-tmpfiles or manually)
  if [[ -n "${VV_CHROOT_INSTALL:-}" ]]; then
    # In chroot, only add to fstab
    show_info "$MSG_SETUP_SWAPFILE_FSTAB (${SWAPFILE_SIZE})..."
    echo "# Swapfile (create manually: dd if=/dev/zero of=/swapfile bs=1M count=$((${SWAPFILE_SIZE%G} * 1024)) && chmod 600 /swapfile && mkswap /swapfile)" | sudo tee -a /etc/fstab
    echo '/swapfile none swap defaults,pri=10 0 0' | sudo tee -a /etc/fstab
    show_success "$MSG_SWAPFILE_FSTAB_OK"
  else
    # Outside chroot, create swapfile immediately
    show_info "$MSG_CREATE_SWAPFILE (${SWAPFILE_SIZE})..."

    # Detect filesystem type (for Btrfs special handling)
    ROOT_FS=$(df --output=fstype / | tail -n1)

    # For Btrfs: create empty file and disable COW BEFORE writing data
    if [[ "$ROOT_FS" == "btrfs" ]]; then
      show_info "Detected Btrfs, preparing swapfile with NOCOW..."
      # 1. Create empty file
      sudo truncate -s 0 /swapfile
      # 2. Set NOCOW attribute (must be on empty file!)
      sudo chattr +C /swapfile
      # 3. Set permissions
      sudo chmod 600 /swapfile
      # 4. Allocate space
      sudo dd if=/dev/zero of=/swapfile bs=1M count=$((${SWAPFILE_SIZE%G} * 1024)) status=progress
    else
      # For ext4/XFS: standard creation
      sudo dd if=/dev/zero of=/swapfile bs=1M count=$((${SWAPFILE_SIZE%G} * 1024)) status=progress
      sudo chmod 600 /swapfile
    fi

    sudo mkswap /swapfile

    if ! grep -q '/swapfile' /etc/fstab; then
      echo '/swapfile none swap defaults,pri=10 0 0' | sudo tee -a /etc/fstab
    fi

    sudo swapon /swapfile
    show_success "$MSG_SWAPFILE_CREATED"
  fi
else
  show_success "$MSG_SWAPFILE_EXISTS"
fi

# Activate zram (only outside chroot)
if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
  if systemctl is-active --quiet systemd-zram-setup@zram0.service; then
    show_success "$MSG_ZRAM_ACTIVE"
  else
    sudo systemctl daemon-reload
    sudo systemctl start systemd-zram-setup@zram0.service
    show_success "$MSG_ZRAM_ACTIVATED"
  fi

  # Show final swap configuration
  echo ""
  show_header "$MSG_SWAP_CONFIG"
  swapon --show
  echo ""
else
  show_info "$MSG_ZRAM_BOOT_MESSAGE"
fi

show_success "$MSG_SWAP_OK"
