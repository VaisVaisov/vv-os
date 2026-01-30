#!/bin/bash
# Optimize fstab mount options for different filesystems and disk types

show_header "$MSG_FSTAB_OPTIMIZE_HEADER"

# Backup original fstab
cp /etc/fstab /etc/fstab.backup
show_info "$MSG_FSTAB_BACKUP_CREATED: /etc/fstab.backup"

# Function to detect disk type (SSD=0, HDD=1)
get_disk_type() {
  local device=$1
  # Extract base device name (e.g., /dev/sda1 -> sda, /dev/nvme0n1p2 -> nvme0n1)
  local base_device=$(echo "$device" | sed 's/[0-9]*$//' | sed 's/p$//')
  local base_name=$(basename "$base_device")

  # Check ROTA (rotational): 0=SSD, 1=HDD
  local rota=$(lsblk -d -n -o ROTA "/dev/$base_name" 2>/dev/null)
  echo "$rota"
}

# Create temporary file for new fstab
temp_fstab=$(mktemp)

# Process each line in fstab
while IFS= read -r line; do
  # Skip comments and empty lines
  if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
    echo "$line" >> "$temp_fstab"
    continue
  fi

  # Skip special filesystems (swap, tmpfs, etc.)
  if echo "$line" | grep -qE "^(tmpfs|swap|proc|sysfs|devpts|securityfs|/swapfile)"; then
    echo "$line" >> "$temp_fstab"
    continue
  fi

  # Parse fstab line
  device=$(echo "$line" | awk '{print $1}')
  mountpoint=$(echo "$line" | awk '{print $2}')
  fstype=$(echo "$line" | awk '{print $3}')
  options=$(echo "$line" | awk '{print $4}')
  dump=$(echo "$line" | awk '{print $5}')
  pass=$(echo "$line" | awk '{print $6}')

  # Get device from UUID if needed
  if [[ "$device" =~ ^UUID= ]]; then
    uuid=$(echo "$device" | cut -d'=' -f2)
    real_device=$(blkid -U "$uuid" 2>/dev/null)
  else
    real_device="$device"
  fi

  # Detect disk type
  if [[ -n "$real_device" ]]; then
    disk_type=$(get_disk_type "$real_device")
  else
    disk_type="1"  # Default to HDD if can't detect
  fi

  # Optimize options based on filesystem type and disk type
  case "$fstype" in
    btrfs)
      if [[ "$disk_type" == "0" ]]; then
        # SSD
        new_options="rw,noatime,compress=zstd:1,ssd,discard=async,space_cache=v2"
      else
        # HDD
        new_options="rw,noatime,compress=zstd:3,autodefrag,space_cache=v2"
      fi

      # Preserve subvol= option if present
      if echo "$options" | grep -q "subvol="; then
        subvol=$(echo "$options" | grep -oP 'subvol=[^\s,]+')
        new_options="${new_options},${subvol}"
      fi

      # btrfs fsck order should be 0
      pass="0"
      ;;

    ext4)
      # Same for SSD and HDD
      new_options="defaults,noatime,errors=remount-ro"

      # fsck order: 1 for root, 2 for others
      if [[ "$mountpoint" == "/" ]]; then
        pass="1"
      else
        pass="2"
      fi
      ;;

    xfs)
      # Same for SSD and HDD
      new_options="defaults"
      # Can also use: rw,relatime,attr2,inode64,noquota

      # xfs fsck order should be 0
      pass="0"
      ;;

    vfat)
      # Keep original options for vfat (usually EFI)
      new_options="$options"
      ;;

    *)
      # Unknown filesystem, keep original
      new_options="$options"
      ;;
  esac

  # Write optimized line
  printf "%-45s %-15s %-8s %-60s %s %s\n" "$device" "$mountpoint" "$fstype" "$new_options" "$dump" "$pass" >> "$temp_fstab"

done < /etc/fstab

# Replace fstab with optimized version
mv "$temp_fstab" /etc/fstab
chmod 644 /etc/fstab

show_success "$MSG_FSTAB_OPTIMIZED"
show_info "$MSG_FSTAB_BACKUP_SAVED"

# Show optimized fstab
echo ""
show_header "$MSG_FSTAB_OPTIMIZED_HEADER"
cat /etc/fstab
echo ""
