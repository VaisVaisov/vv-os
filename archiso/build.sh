#!/bin/bash
# VV OS ISO Builder

set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="/tmp/archiso-tmp"
OUT_DIR="$PROFILE_DIR/out"
REPO_DIR="$PROFILE_DIR/repo"

echo "=== VV OS ISO Builder ==="
echo ""

# Check that script is running on Arch Linux
if [ ! -f /etc/arch-release ]; then
  echo "❌ This script must be run on Arch Linux"
  exit 1
fi

# Check for archiso
if ! command -v mkarchiso &>/dev/null; then
  echo "→ Installing archiso..."
  sudo pacman -Sy --needed --noconfirm archiso
fi

# Determine build user for AUR packages
BUILD_USER="${SUDO_USER:-$(getent passwd | awk -F: '$3 == 1000 {print $1}')}"
echo "→ Building as root, AUR packages will be built by user: $BUILD_USER"
echo ""

# Clean previous builds
echo "→ Cleaning previous builds..."
sudo rm -rf "$WORK_DIR"

# Check and clean /tmp/archiso-tmp
TMP_DIR="/tmp/archiso-tmp"
echo "→ Cleaning old directory contents $TMP_DIR..."
if [ -d "$TMP_DIR" ] && [ "$(ls -A "$TMP_DIR")" ]; then
    sudo rm -rf "$TMP_DIR/*"
else
    echo "→ $TMP_DIR is empty, nothing to delete"
fi

# Check and clean OUT_DIR
mkdir -p "$OUT_DIR"
echo "→ Removing old files in $OUT_DIR..."
if [ "$(ls -A "$OUT_DIR")" ]; then
    rm -rf "$OUT_DIR"/*
else
    echo "→ $OUT_DIR is empty, nothing to delete"
fi

# Remove vv-os repository from pacman.conf (if left from previous build)
if grep -q "\[vv-os\]" /etc/pacman.conf; then
    echo "→ Removing old vv-os repository from pacman.conf..."
    sed -i '/\[vv-os\]/,/^$/d' /etc/pacman.conf
fi

# Create and clean REPO_DIR
mkdir -p "$REPO_DIR"
echo "→ Cleaning local repository..."
if [ "$(ls -A "$REPO_DIR")" ]; then
    rm -rf "$REPO_DIR"/*
    echo "→ Old packages removed"
else
    echo "→ $REPO_DIR is empty, nothing to delete"
fi

# Prepare airootfs
echo "→ Preparing airootfs..."
rm -rf "$PROFILE_DIR/airootfs/root/vv-os"
mkdir -p "$PROFILE_DIR/airootfs/root/vv-os"

# Create empty directories for bootloader configs
mkdir -p "$PROFILE_DIR/syslinux"
mkdir -p "$PROFILE_DIR/grub"

# Copy vv-os to ISO (without recursion into archiso)
echo "→ Copying vv-os to ISO..."
rsync -a \
  --exclude archiso \
  --exclude .git \
  --exclude '*/noctalia-shell/' \
  --exclude '*/plymouth-themes/' \
  --exclude '*/sddm-astronaut-theme/' \
  --exclude '*/gpu-screen-recorder/' \
  --exclude '*/rate-mirrors-bin/' \
  --exclude '*.pkg.tar.zst' \
  --exclude '*/src/' \
  --exclude '*/pkg/' \
  "$PROFILE_DIR/../vv-installer/" \
  "$PROFILE_DIR/airootfs/root/vv-os/"

# Install scripts to system
mkdir -p "$PROFILE_DIR/airootfs/usr/local/bin"
cp "$PROFILE_DIR/airootfs/root/vv-os/vv-live-installer.sh" "$PROFILE_DIR/airootfs/usr/local/bin/"
chmod +x "$PROFILE_DIR/airootfs/usr/local/bin/vv-live-installer.sh"

# === POLKIT: Allow live user to run installer without password ===
echo "→ Configuring polkit for installer..."
mkdir -p "$PROFILE_DIR/airootfs/etc/polkit-1/localauthority/50-local.d/"
cp "$PROFILE_DIR/../vv-installer/configs/polkit/49-vv-installer.pkla" \
   "$PROFILE_DIR/airootfs/etc/polkit-1/localauthority/50-local.d/"

# Set execute permissions for all .sh files
echo "→ Setting execute permissions for scripts..."
find "$PROFILE_DIR/airootfs/root/vv-os" -type f -name "*.sh" -exec chmod +x {} \;

# ==============================================================================
# AUR PACKAGES BUILD
# ==============================================================================

AUR_PKGS=(
  "gpu-screen-recorder"
  "noctalia-shell-git"
  "sddm-astronaut-theme"
  "plymouth-themes-adi1090x-git"
  "rate-mirrors-bin"
)

echo "→ Building AUR packages..."
pacman -Sy --needed --noconfirm base-devel git

# Give BUILD_USER permission to install packages without password (for makepkg -s)
echo "$BUILD_USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" > /etc/sudoers.d/99-aur-build
chmod 0440 /etc/sudoers.d/99-aur-build

chmod o+x "$HOME" || true
chmod -R o+r "$REPO_DIR"

# Update AUR packages from AUR (get latest PKGBUILD)
echo "→ Updating AUR packages from AUR..."
BACKUP_DIR="$PROFILE_DIR/aur-backup"
mkdir -p "$BACKUP_DIR"

for pkg in "${AUR_PKGS[@]}"; do
  PKG_DIR="$PROFILE_DIR/../vv-installer/$pkg"
  echo "  → Updating $pkg..."

  # Backup old PKGBUILD (if exists) - old backup will be overwritten
  if [ -d "$PKG_DIR" ]; then
    rm -rf "$BACKUP_DIR/$pkg"
    cp -r "$PKG_DIR" "$BACKUP_DIR/$pkg"
  fi

  # Clone fresh from AUR
  rm -rf "$PKG_DIR"
  if git clone --depth=1 "https://aur.archlinux.org/${pkg}.git" "$PKG_DIR" 2>/dev/null; then
    echo "    ✅ Updated from AUR"
  else
    echo "    ⚠️ Clone failed, restoring backup"
    # Restore from backup if clone failed
    if [ -d "$BACKUP_DIR/$pkg" ]; then
      cp -r "$BACKUP_DIR/$pkg" "$PKG_DIR"
      echo "    ✅ Restored from backup"
    else
      echo "    ❌ No backup available, build will fail"
    fi
  fi
done
echo ""

for pkg in "${AUR_PKGS[@]}"; do
  PKG_SRC="$PROFILE_DIR/../vv-installer/$pkg"
  if [ -d "$PKG_SRC" ]; then
    echo "  → Building $pkg..."
    chown -R "$BUILD_USER" "$PKG_SRC"
    cd "$PKG_SRC"

    # Clean old build files
    rm -f *.pkg.tar.zst
    rm -rf src/ pkg/

    # Clean git clones for specific packages
    case "$pkg" in
      plymouth-themes-adi1090x-git)
        rm -rf plymouth-themes
        ;;
      noctalia-shell-git)
        rm -rf noctalia-shell
        ;;
    esac
    if sudo -u "$BUILD_USER" env OPTIONS='!debug' makepkg -scf --noconfirm; then
      PKG_FILE=$(ls *.pkg.tar.zst | grep -v -- "-debug-" | head -n1)
      cp "$PKG_FILE" "$REPO_DIR/"

      # Update local repository after each package
      repo-add "$REPO_DIR/vv-os.db.tar.gz" "$REPO_DIR"/*.pkg.tar.zst &>/dev/null

      # Add repository to system (only once)
      REAL_REPO_DIR="$(realpath "$REPO_DIR")"
      if ! grep -q "\[vv-os\]" /etc/pacman.conf; then
        sed -i "1i [vv-os]\nSigLevel = Optional TrustAll\nServer = file://$REAL_REPO_DIR\n" /etc/pacman.conf
      fi
      pacman -Sy &>/dev/null

      # Patch sddm-astronaut-theme to use cyberpunk.conf
      if [ "$pkg" = "sddm-astronaut-theme" ]; then
        echo "    → Patching theme to use cyberpunk.conf..."
        pacman -U --noconfirm "$REPO_DIR/$PKG_FILE" &>/dev/null
        METADATA_FILE="/usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
        if [ -f "$METADATA_FILE" ]; then
          sed -i 's|ConfigFile=Themes/astronaut.conf|ConfigFile=Themes/cyberpunk.conf|' "$METADATA_FILE"
          echo "    ✅ Theme configured for cyberpunk"
        fi
      fi

      echo "    ✅ $pkg → repository"
    else
      echo "    ❌ Build failed for $pkg"
      exit 1
    fi
    cd - &>/dev/null
  else
    echo "  ⚠️ $pkg not found"
  fi
done

# ==============================================================================
# PACMAN.CONF + BUILD ISO
# ==============================================================================
TEMP_CONF=$(mktemp)
cat "$PROFILE_DIR/pacman.conf" > "$TEMP_CONF"

# Use realpath for guaranteed access in chroot
REAL_REPO_DIR="$(realpath "$REPO_DIR")"
sed -i "1i [vv-os]\nSigLevel = Optional TrustAll\nServer = file://$REAL_REPO_DIR\n" "$TEMP_CONF"

# Clean build artifacts of AUR packages (save disk space)
echo "→ Cleaning AUR package build artifacts..."
for pkg in "${AUR_PKGS[@]}"; do
  sudo rm -rf "$PROFILE_DIR/airootfs/root/vv-os/$pkg"
  echo "    ✅ Cleaned $pkg"
done

# Build ISO
echo ""
echo "→ Building ISO..."
sudo mkarchiso -v -C "$TEMP_CONF" -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

# Cleanup
echo "→ Cleaning temporary files..."
rm -f "$TEMP_CONF"
sed -i '/\[vv-os\]/,/^$/d' /etc/pacman.conf

# Clean /tmp from build artifacts (Docker doesn't auto-clean)
echo "→ Cleaning /tmp build artifacts..."
rm -rf /tmp/vv-* /tmp/*_old.PKGBUILD 2>/dev/null || true

# Note: AUR backups in archiso/aur-backup/ are kept for next build as fallback

echo ""
echo "✅ ISO built successfully!"
echo "→ ISO is located at: $OUT_DIR/"
ls -lh "$OUT_DIR"/*.iso
