#!/bin/bash
# Configure snapper for automatic snapshots

show_info "$MSG_SETUP_SNAPPER"

# Check if root filesystem is btrfs
ROOT_FS=$(df --output=fstype / | tail -n1)

if [[ "$ROOT_FS" != "btrfs" ]]; then
  show_warning "$MSG_SNAPPER_REQUIRES_BTRFS (detected: $ROOT_FS)"
  show_info "$MSG_SNAPPER_SKIP"
  exit 0
fi

show_info "$MSG_SNAPPER_BTRFS_DETECTED"

# Check if snapper config already exists
if snapper list-configs | grep -q "root"; then
  show_success "$MSG_SNAPPER_CONFIG_EXISTS"
else
  # Create snapper config for root
  show_info "$MSG_SNAPPER_CREATE_CONFIG"

  # Create config (this will create /.snapshots subvolume)
  snapper -c root create-config /

  # Configure snapper settings
  snapper -c root set-config TIMELINE_CREATE="yes"
  snapper -c root set-config TIMELINE_CLEANUP="yes"

  # Keep snapshots for reasonable time
  snapper -c root set-config TIMELINE_LIMIT_HOURLY="5"
  snapper -c root set-config TIMELINE_LIMIT_DAILY="7"
  snapper -c root set-config TIMELINE_LIMIT_WEEKLY="4"
  snapper -c root set-config TIMELINE_LIMIT_MONTHLY="6"
  snapper -c root set-config TIMELINE_LIMIT_YEARLY="2"

  # Disk space management
  # SPACE_LIMIT: Max % of disk space snapshots can use (default: 0.5 = 50%)
  snapper -c root set-config SPACE_LIMIT="0.3"  # 30% max

  # FREE_LIMIT: Min % of free space to keep (default: 0.2 = 20%)
  snapper -c root set-config FREE_LIMIT="0.15"  # Keep 15% free

  # When space limits exceeded, snapper will auto-delete oldest snapshots
  show_info "$MSG_SNAPPER_SPACE_LIMITS (max 30% disk usage, keep 15% free)"

  show_success "$MSG_SNAPPER_CONFIG_CREATED"
fi

# Create Initial Snapshot (post-install state)
show_info "$MSG_SNAPPER_INITIAL_SNAPSHOT"

SNAPSHOT_NUMBER=$(snapper -c root create --description "Initial VV OS Installation" --cleanup-algorithm number --print-number)

if [[ -n "$SNAPSHOT_NUMBER" ]]; then
  show_success "$MSG_SNAPPER_SNAPSHOT_CREATED (#$SNAPSHOT_NUMBER)"
else
  show_warning "$MSG_SNAPPER_SNAPSHOT_FAILED"
fi

# Install snapshot restore detection scripts
show_info "$MSG_SNAPPER_INSTALL_RESTORE_SCRIPTS"

cp "$VV_SCRIPTS/vv-snapshot-restore-check" /usr/local/bin/
chmod +x /usr/local/bin/vv-snapshot-restore-check

cp "$VV_SCRIPTS/vv-snapshot-restore-prompt" $VV_USER_HOME/.local/bin/
chown "$VV_USER:$VV_USER" $VV_USER_HOME/.local/bin/vv-snapshot-restore-prompt
chmod +x $VV_USER_HOME/.local/bin/vv-snapshot-restore-prompt

# Install systemd service for boot detection
if [[ -f "$VV_CONFIGS/systemd/system/vv-snapshot-check.service" ]]; then
  cp "$VV_CONFIGS/systemd/system/vv-snapshot-check.service" /etc/systemd/system/

  if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
    systemctl daemon-reload
    systemctl enable vv-snapshot-check.service
    show_success "$MSG_SNAPPER_RESTORE_SERVICE_ENABLED"
  else
    show_info "$MSG_SNAPPER_RESTORE_SERVICE_BOOT_MESSAGE"
  fi
fi

# Install Hyprland autostart for user prompt
if [[ -f "$VV_CONFIGS/hypr/snapshot-restore-prompt.conf" ]]; then
  cp "$VV_CONFIGS/hypr/snapshot-restore-prompt.conf" $VV_USER_HOME/.config/hypr/
  chown "$VV_USER:$VV_USER" $VV_USER_HOME/.config/hypr/snapshot-restore-prompt.conf
fi

# Configure grub-btrfs for snapshot boot entries
show_info "$MSG_SNAPPER_GRUB_BTRFS"

# Enable grub-btrfsd daemon (auto-updates GRUB on snapshot creation)
if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
  systemctl enable --now grub-btrfsd.service
  show_success "$MSG_SNAPPER_GRUB_BTRFS_ENABLED"
else
  systemctl enable grub-btrfsd.service
  show_info "$MSG_SNAPPER_GRUB_BTRFS_BOOT_MESSAGE"
fi

# Configure grub-btrfs settings
if [[ ! -f /etc/default/grub-btrfs/config ]]; then
  mkdir -p /etc/default/grub-btrfs
  cat > /etc/default/grub-btrfs/config <<'EOF'
# grub-btrfs configuration
# Snapshots will appear in GRUB menu under "VV OS snapshots"

# Submenu name
GRUB_BTRFS_SUBMENUNAME="VV OS snapshots"

# Limit number of snapshots in menu
GRUB_BTRFS_LIMIT="50"

# Show snapshot number and date
GRUB_BTRFS_SHOW_SNAPSHOTS_FOUND="true"

# Include snapshots from /.snapshots
GRUB_BTRFS_OVERRIDE_BOOT_PARTITION_DETECTION="true"
EOF
  show_success "$MSG_SNAPPER_GRUB_BTRFS_CONFIG"
fi

# Enable automatic snapshots (only outside chroot)
if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
  show_info "$MSG_SNAPPER_ENABLE_TIMERS"

  systemctl enable --now snapper-timeline.timer
  systemctl enable --now snapper-cleanup.timer

  show_success "$MSG_SNAPPER_TIMERS_ENABLED"

  # Regenerate GRUB to include snapshots
  show_info "$MSG_SNAPPER_REGEN_GRUB"
  grub-mkconfig -o /boot/grub/grub.cfg
  show_success "$MSG_SNAPPER_GRUB_UPDATED"

  # Show current snapshots
  echo ""
  show_header "$MSG_SNAPPER_LIST"
  snapper -c root list
  echo ""
else
  show_info "$MSG_SNAPPER_TIMERS_BOOT_MESSAGE"
fi

show_success "$MSG_SNAPPER_OK"
