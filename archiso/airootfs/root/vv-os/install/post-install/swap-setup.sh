#!/bin/bash
# Настройка zram + swapfile с динамическим расчетом

show_info "$MSG_SETUP_SWAP"

# В chroot окружении только настраиваем конфиги, swapfile создастся при загрузке
if [[ -n "${VV_CHROOT_INSTALL:-}" ]]; then
  show_info "$MSG_CHROOT_MODE"
fi

# Получаем объем RAM в GB
RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
if [[ "$RAM_GB" -eq 0 ]]; then
  # В chroot может не определиться, берем 16GB как default
  RAM_GB=16
fi

# Динамический расчет swapfile
if [ "$RAM_GB" -lt 8 ]; then
  SWAPFILE_SIZE="${RAM_GB}G"
elif [ "$RAM_GB" -le 16 ]; then
  SWAPFILE_SIZE="$((RAM_GB / 2))G"
else
  # Для систем с 16+ GB RAM - интерактивный выбор
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

# Устанавливаем zram-generator (если еще не установлен)
if ! pacman -Q zram-generator &>/dev/null; then
  show_info "$MSG_INSTALL_ZRAM"
  sudo pacman -S --noconfirm --needed zram-generator
fi

# Создаем конфиг zram-generator
show_info "$MSG_SETUP_ZRAM"
sudo tee /etc/systemd/zram-generator.conf >/dev/null <<EOF
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

# Проверяем существование swapfile и создаем если нужно
if [[ ! -f /swapfile ]] && ! grep -q '/swapfile' /etc/fstab 2>/dev/null; then
  # Добавляем swapfile в fstab (создастся при первой загрузке через systemd-tmpfiles или вручную)
  if [[ -n "${VV_CHROOT_INSTALL:-}" ]]; then
    # В chroot только добавляем в fstab
    show_info "$MSG_SETUP_SWAPFILE_FSTAB (${SWAPFILE_SIZE})..."
    echo "# Swapfile (создать вручную: dd if=/dev/zero of=/swapfile bs=1M count=$((${SWAPFILE_SIZE%G} * 1024)) && chmod 600 /swapfile && mkswap /swapfile)" | sudo tee -a /etc/fstab
    echo '/swapfile none swap defaults,pri=10 0 0' | sudo tee -a /etc/fstab
    show_success "$MSG_SWAPFILE_FSTAB_OK"
  else
    # Вне chroot создаем swapfile сразу
    show_info "$MSG_CREATE_SWAPFILE (${SWAPFILE_SIZE})..."
    sudo dd if=/dev/zero of=/swapfile bs=1M count=$((${SWAPFILE_SIZE%G} * 1024)) status=progress
    sudo chmod 600 /swapfile
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

# Активируем zram (только вне chroot)
if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
  if systemctl is-active --quiet systemd-zram-setup@zram0.service; then
    show_success "$MSG_ZRAM_ACTIVE"
  else
    sudo systemctl daemon-reload
    sudo systemctl start systemd-zram-setup@zram0.service
    show_success "$MSG_ZRAM_ACTIVATED"
  fi

  # Показываем итоговую конфигурацию swap
  echo ""
  show_header "$MSG_SWAP_CONFIG"
  swapon --show
  echo ""
else
  show_info "$MSG_ZRAM_BOOT_MESSAGE"
fi

show_success "$MSG_SWAP_OK"
