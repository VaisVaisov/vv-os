#!/bin/bash
# VV OS ISO Builder

set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="/tmp/archiso-tmp"
OUT_DIR="$PROFILE_DIR/out"
REPO_DIR="$PROFILE_DIR/repo"

echo "=== VV OS ISO Builder ==="
echo ""

# Проверка что скрипт запущен на Arch Linux
if [ ! -f /etc/arch-release ]; then
  echo "❌ Этот скрипт должен запускаться на Arch Linux"
  exit 1
fi

# Проверка наличия archiso
if ! command -v mkarchiso &>/dev/null; then
  echo "→ Установка archiso..."
  sudo pacman -Sy --needed --noconfirm archiso
fi

# Определяем пользователя для сборки AUR
BUILD_USER="${SUDO_USER:-$(getent passwd | awk -F: '$3 == 1000 {print $1}')}"
echo "→ Сборка выполняется от root, пакеты AUR собираются пользователем: $BUILD_USER"
echo ""

# Очистка предыдущих сборок
echo "→ Очистка предыдущих сборок..."
sudo rm -rf "$WORK_DIR"

# Проверка и очистка /tmp/archiso-tmp
TMP_DIR="/tmp/archiso-tmp"
echo "→ Очистка содержимого старого каталога $TMP_DIR..."
if [ -d "$TMP_DIR" ] && [ "$(ls -A "$TMP_DIR")" ]; then
    sudo rm -rf "$TMP_DIR/*"
else
    echo "→ $TMP_DIR пустой, удалять нечего"
fi

# Проверка и очистка OUT_DIR
mkdir -p "$OUT_DIR"
echo "→ Удаление старых файлов в $OUT_DIR..."
if [ "$(ls -A "$OUT_DIR")" ]; then
    rm -rf "$OUT_DIR"/*
else
    echo "→ $OUT_DIR пустой, удалять нечего"
fi

# Удаляем репозиторий vv-os из pacman.conf (если остался от прошлой сборки)
if grep -q "\[vv-os\]" /etc/pacman.conf; then
    echo "→ Удаление старого репозитория vv-os из pacman.conf..."
    sed -i '/\[vv-os\]/,/^$/d' /etc/pacman.conf
fi

# Создание и очистка REPO_DIR
mkdir -p "$REPO_DIR"
echo "→ Очистка локального репозитория..."
if [ "$(ls -A "$REPO_DIR")" ]; then
    rm -rf "$REPO_DIR"/*
    echo "→ Старые пакеты удалены"
else
    echo "→ $REPO_DIR пустой, удалять нечего"
fi

# Подготовка airootfs
echo "→ Подготовка airootfs..."
rm -rf "$PROFILE_DIR/airootfs/root/vv-os"
mkdir -p "$PROFILE_DIR/airootfs/root/vv-os"

# Создание пустых директорий для bootloader конфигов
mkdir -p "$PROFILE_DIR/syslinux"
mkdir -p "$PROFILE_DIR/grub"

# Копирование vv-os в ISO (без рекурсии в archiso)
echo "→ Копирование vv-os в ISO..."
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

# Установка скриптов в систему
mkdir -p "$PROFILE_DIR/airootfs/usr/local/bin"
cp "$PROFILE_DIR/airootfs/root/vv-os/vv-live-installer.sh" "$PROFILE_DIR/airootfs/usr/local/bin/"
chmod +x "$PROFILE_DIR/airootfs/usr/local/bin/vv-live-installer.sh"

# === POLKIT: Allow live user to run installer without password ===
echo "→ Настройка polkit для запуска установщика..."
mkdir -p "$PROFILE_DIR/airootfs/etc/polkit-1/localauthority/50-local.d/"
cp "$PROFILE_DIR/../vv-installer/configs/polkit/49-vv-installer.pkla" \
   "$PROFILE_DIR/airootfs/etc/polkit-1/localauthority/50-local.d/"

# Установка прав на выполнение для всех .sh файлов
echo "→ Установка прав на выполнение для скриптов..."
find "$PROFILE_DIR/airootfs/root/vv-os" -type f -name "*.sh" -exec chmod +x {} \;

# ==============================================================================
# СБОРКА ПАКЕТОВ AUR
# ==============================================================================

AUR_PKGS=(
  "gpu-screen-recorder"
  "noctalia-shell-git"
  "sddm-astronaut-theme"
  "plymouth-themes-adi1090x-git"
  "rate-mirrors-bin"
)

echo "→ Сборка пакетов из AUR..."
pacman -Sy --needed --noconfirm base-devel git

# Даём BUILD_USER права на установку пакетов без пароля (для makepkg -s)
echo "$BUILD_USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" > /etc/sudoers.d/99-aur-build
chmod 0440 /etc/sudoers.d/99-aur-build

chmod o+x "$HOME" || true
chmod -R o+r "$REPO_DIR"

for pkg in "${AUR_PKGS[@]}"; do
  PKG_SRC="$PROFILE_DIR/../vv-installer/$pkg"
  if [ -d "$PKG_SRC" ]; then
    echo "  → Сборка $pkg..."
    chown -R "$BUILD_USER" "$PKG_SRC"
    cd "$PKG_SRC"

    # Очистка старых сборочных файлов
    rm -f *.pkg.tar.zst
    rm -rf src/ pkg/

    # Очистка git клонов для конкретных пакетов
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

      # Обновляем локальный репозиторий после каждого пакета
      repo-add "$REPO_DIR/vv-os.db.tar.gz" "$REPO_DIR"/*.pkg.tar.zst &>/dev/null

      # Добавляем репозиторий в систему (только один раз)
      REAL_REPO_DIR="$(realpath "$REPO_DIR")"
      if ! grep -q "\[vv-os\]" /etc/pacman.conf; then
        sed -i "1i [vv-os]\nSigLevel = Optional TrustAll\nServer = file://$REAL_REPO_DIR\n" /etc/pacman.conf
      fi
      pacman -Sy &>/dev/null

      # Патчим sddm-astronaut-theme для использования cyberpunk.conf
      if [ "$pkg" = "sddm-astronaut-theme" ]; then
        echo "    → Патчим тему на cyberpunk.conf..."
        pacman -U --noconfirm "$REPO_DIR/$PKG_FILE" &>/dev/null
        METADATA_FILE="/usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
        if [ -f "$METADATA_FILE" ]; then
          sed -i 's|ConfigFile=Themes/astronaut.conf|ConfigFile=Themes/cyberpunk.conf|' "$METADATA_FILE"
          echo "    ✅ Тема настроена на cyberpunk"
        fi
      fi

      echo "    ✅ $pkg → репозиторий"
    else
      echo "    ❌ Ошибка сборки $pkg"
      exit 1
    fi
    cd - &>/dev/null
  else
    echo "  ⚠️ $pkg не найден"
  fi
done

# ==============================================================================
# PACMAN.CONF + СБОРКА ОБРАЗА
# ==============================================================================
TEMP_CONF=$(mktemp)
cat "$PROFILE_DIR/pacman.conf" > "$TEMP_CONF"

# Используем realpath для гарантированного доступа в chroot
REAL_REPO_DIR="$(realpath "$REPO_DIR")"
sed -i "1i [vv-os]\nSigLevel = Optional TrustAll\nServer = file://$REAL_REPO_DIR\n" "$TEMP_CONF"

# Очистка build-артефактов AUR пакетов (экономия места на диске)
echo "→ Очистка build-артефактов AUR пакетов..."
for pkg in "${AUR_PKGS[@]}"; do
  sudo rm -rf "$PROFILE_DIR/airootfs/root/vv-os/$pkg"
  echo "    ✅ Очищен $pkg"
done

# Сборка ISO
echo ""
echo "→ Сборка ISO..."
sudo mkarchiso -v -C "$TEMP_CONF" -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

# Очистка
echo "→ Очистка временных файлов..."
rm -f "$TEMP_CONF"
sed -i '/\[vv-os\]/,/^$/d' /etc/pacman.conf

echo ""
echo "✅ ISO собран успешно!"
echo "→ ISO находится в: $OUT_DIR/"
ls -lh "$OUT_DIR"/*.iso
