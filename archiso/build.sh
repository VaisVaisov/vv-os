#!/bin/bash
# VV OS ISO Builder

set -e

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
mkdir -p "$OUT_DIR"

# Копирование vv-os в airootfs
echo "→ Копирование vv-os в ISO..."
rm -rf "$PROFILE_DIR/airootfs/root/vv-os"
cp -r "$PROFILE_DIR/../" "$PROFILE_DIR/airootfs/root/vv-os/"
# Удаляем ненужное из копии
rm -rf "$PROFILE_DIR/airootfs/root/vv-os/archiso"
rm -rf "$PROFILE_DIR/airootfs/root/vv-os/.git"

# Сборка ISO
echo "→ Сборка ISO..."
echo ""
sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo "✅ ISO собран успешно!"
echo "→ ISO находится в: $OUT_DIR/"
ls -lh "$OUT_DIR"/*.iso
