#!/bin/bash
# VV OS ISO Builder

set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="/tmp/archiso-tmp"
OUT_DIR="$PROFILE_DIR/out"

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

# Сборка ISO
echo ""
echo "→ Сборка ISO..."
sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo "✅ ISO собран успешно!"
echo "→ ISO находится в: $OUT_DIR/"
ls -lh "$OUT_DIR"/*.iso
