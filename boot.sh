#!/bin/bash
# VV OS - Онлайн установщик
# Загружает VV OS из GitHub и запускает vv-live-installer.sh

set -e

REPO_URL="https://github.com/vaisvaisov/vv-os.git"
INSTALL_DIR="/tmp/vv-os"

# ASCII арт
clear
cat << "LOGO"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║           ██╗   ██╗██╗   ██╗     ██████╗ ███████╗            ║
║           ██║   ██║██║   ██║    ██╔═══██╗██╔════╝            ║
║           ██║   ██║██║   ██║    ██║   ██║███████╗            ║
║           ╚██╗ ██╔╝╚██╗ ██╔╝    ██║   ██║╚════██║            ║
║            ╚████╔╝  ╚████╔╝     ╚██████╔╝███████║            ║
║             ╚═══╝    ╚═══╝       ╚═════╝ ╚══════╝            ║
║                                                              ║
║               VV OS - Онлайн Установщик                      ║
║                                                              ║
║           Arch Linux + Hyprland + Noctalia Shell             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

LOGO

echo ""
echo "Загрузка VV OS из GitHub..."
echo ""

# Проверка что скрипт запущен из Arch Live ISO
if [[ ! -f /etc/arch-release ]]; then
  echo "❌ ОШИБКА: Этот скрипт должен запускаться из Arch Linux Live ISO"
  exit 1
fi

# Проверка интернет соединения
if ! ping -c 1 github.com &>/dev/null; then
  echo "❌ ОШИБКА: Нет подключения к интернету"
  echo "Подключитесь к сети через wifi-menu или ethernet и попробуйте снова"
  exit 1
fi

# Установка git если не установлен
if ! command -v git &>/dev/null; then
  echo "→ Установка git..."
  pacman -Sy --noconfirm --needed git
fi

# Удаляем старую директорию если существует
if [[ -d "$INSTALL_DIR" ]]; then
  echo "→ Удаление старой версии..."
  rm -rf "$INSTALL_DIR"
fi

# Клонируем репозиторий
echo "→ Загрузка VV OS..."
git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"

# Переходим в директорию
cd "$INSTALL_DIR"

# Делаем vv-live-installer.sh исполняемым
chmod +x vv-live-installer.sh

echo ""
echo "✓ VV OS загружен успешно!"
echo ""
echo "Запуск установщика..."
echo ""

# Запускаем установщик
exec ./vv-live-installer.sh
