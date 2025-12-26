#!/bin/bash
# VV OS Installer - Wrapper для archinstall
# Предоставляет user-friendly выбор разметки диска

set -eEo pipefail

# Проверка что скрипт запущен из Arch Live ISO
if [[ ! -f /etc/arch-release ]]; then
  echo "Этот скрипт должен запускаться из Arch Linux Live ISO"
  exit 1
fi

# Проверка наличия gum
if ! command -v gum &>/dev/null; then
  echo "Установка gum..."
  pacman -Sy --noconfirm --needed gum
fi

# ASCII арт приветствие
clear
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║           ██╗   ██╗██╗   ██╗     ██████╗ ███████╗            ║
║           ██║   ██║██║   ██║    ██╔═══██╗██╔════╝            ║
║           ██║   ██║██║   ██║    ██║   ██║███████╗            ║
║           ╚██╗ ██╔╝╚██╗ ██╔╝    ██║   ██║╚════██║            ║
║            ╚████╔╝  ╚████╔╝     ╚██████╔╝███████║            ║
║             ╚═══╝    ╚═══╝       ╚═════╝ ╚══════╝            ║
║                                                              ║
║            Добро пожаловать в VV OS Installer!               ║
║                                                              ║
║           Arch Linux + Hyprland + Noctalia Shell             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

EOF

echo ""

# Функция выбора типа разметки
select_partitioning_mode() {
  gum style --foreground 2 --bold "Шаг 1: Выбор типа разметки диска"
  echo ""

  PARTITION_MODE=$(gum choose \
    "С отдельным /home (рекомендуется)" \
    "Всё в root (для минималистов)" \
    "Dual-boot с Windows" \
    "Ручная разметка")

  echo ""
  gum style --foreground 3 "Выбрано: $PARTITION_MODE"
  echo ""
}

# Функция генерации JSON профиля для archinstall
generate_archinstall_profile() {
  local mode="$1"
  local profile_path="/tmp/vv-archinstall-profile.json"

  cat > "$profile_path" <<EOF
{
  "version": "2.8.0",
  "bootloader": "grub",
  "kernels": ["linux"],
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

  # Добавляем disk_config в зависимости от выбора
  case "$mode" in
    "С отдельным /home (рекомендуется)")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Автоматическая разметка с отдельным /home будет настроена интерактивно"
EOF
      ;;
    "Всё в root (для минималистов)")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Автоматическая разметка (всё в root) будет настроена интерактивно"
EOF
      ;;
    "Dual-boot с Windows")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Dual-boot разметка будет настроена интерактивно (используем существующий EFI Windows)"
EOF
      ;;
    "Ручная разметка")
      cat >> "$profile_path" <<'EOF'
  ,
  "!disk_config": "Ручная разметка через archinstall"
EOF
      ;;
  esac

  # Закрываем JSON
  echo "}" >> "$profile_path"

  echo "$profile_path"
}

# Функция запуска archinstall
run_archinstall() {
  local profile="$1"
  local mode="$2"

  gum style --foreground 2 --bold "Шаг 2: Запуск archinstall"
  echo ""

  # Показываем инструкции в зависимости от режима
  case "$mode" in
    "С отдельным /home (рекомендуется)")
      gum style --foreground 6 "Инструкция для разметки:"
      echo "  1. Выберите диск для установки"
      echo "  2. В разметке создайте:"
      echo "     - EFI раздел: 512MB (fat32)"
      echo "     - root раздел: 50GB (ext4)"
      echo "     - home раздел: остальное (ext4)"
      echo ""
      ;;
    "Всё в root (для минималистов)")
      gum style --foreground 6 "Инструкция для разметки:"
      echo "  1. Выберите диск для установки"
      echo "  2. В разметке создайте:"
      echo "     - EFI раздел: 512MB (fat32)"
      echo "     - root раздел: всё остальное (ext4)"
      echo ""
      ;;
    "Dual-boot с Windows)")
      gum style --foreground 6 "Инструкция для dual-boot:"
      echo "  1. НЕ создавайте новый EFI раздел!"
      echo "  2. Используйте существующий EFI раздел Windows"
      echo "  3. Создайте только:"
      echo "     - root раздел: 50GB или на своё усмотрение (ext4)"
      echo "     - home раздел: остальное (ext4, опционально)"
      echo "  4. GRUB автоматически найдёт Windows через os-prober"
      echo ""
      ;;
    "Ручная разметка")
      gum style --foreground 6 "Используйте manual partitioning в archinstall"
      echo ""
      ;;
  esac

  gum confirm "Готовы продолжить с archinstall?" || exit 0

  echo ""
  gum style --foreground 3 "Запуск archinstall..."
  echo ""

  # Запускаем archinstall с профилем
  archinstall --config "$profile"
}

# Главная функция
main() {
  # Выбор типа разметки
  select_partitioning_mode

  # Генерация профиля
  PROFILE=$(generate_archinstall_profile "$PARTITION_MODE")

  # Запуск archinstall
  run_archinstall "$PROFILE" "$PARTITION_MODE"

  # После успешной установки archinstall
  echo ""
  gum style --foreground 2 --bold "✓ Базовая установка Arch завершена!"
  echo ""

  # Chroot post-install - устанавливаем VV OS не выходя из Live ISO
  install_vv_os_chroot
}

# Функция установки VV OS в chroot
install_vv_os_chroot() {
  gum style --foreground 2 --bold "Шаг 3: Установка VV OS (Hyprland + Noctalia)"
  echo ""

  # Определяем путь к VV OS (корневая директория проекта)
  VV_OS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Копируем VV OS в /mnt/tmp/
  show_info() { gum style --foreground 6 "→ $1"; }
  show_success() { gum style --foreground 2 "✓ $1"; }

  show_info "Копирование VV OS в установленную систему..."
  mkdir -p /mnt/tmp/vv-os
  cp -r "$VV_OS_PATH"/* /mnt/tmp/vv-os/

  show_success "VV OS скопирован"
  echo ""

  show_info "Установка VV OS в chroot окружении..."
  show_info "Это займёт 20-30 минут..."
  echo ""

  # Запускаем install.sh в chroot
  arch-chroot /mnt /bin/bash <<'CHROOT_SCRIPT'
export VV_CHROOT_INSTALL=true
cd /tmp/vv-os
bash install.sh
CHROOT_SCRIPT

  # Очищаем временные файлы
  rm -rf /mnt/tmp/vv-os

  echo ""
  show_success "VV OS установлен!"
  echo ""

  gum style --foreground 3 "Система готова к использованию!"
  echo ""
  echo "Перезагрузитесь и выберите Hyprland в display manager"
  echo ""
}

# Запуск
main
