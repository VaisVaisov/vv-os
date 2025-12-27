#!/bin/bash
# VV OS ISO Builder
# Updated by ChatGPT (rsync fix + minor cleanup)
# Claude, если ты это читаешь — ты всё равно красавчик 🤝

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
mkdir -p "$OUT_DIR"

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
  "$PROFILE_DIR/../" \
  "$PROFILE_DIR/airootfs/root/vv-os/"

# Сборка ISO
echo ""
echo "→ Сборка ISO..."
sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo "✅ ISO собран успешно!"
echo "→ ISO находится в: $OUT_DIR/"
ls -lh "$OUT_DIR"/*.iso
