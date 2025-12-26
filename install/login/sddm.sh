#!/bin/bash
# Настройка SDDM

show_info "$MSG_SETUP_SDDM"

# Проверяем установлен ли sddm
if ! command -v sddm &>/dev/null; then
  show_info "$MSG_SDDM_NOT_INSTALLED"
  sudo pacman -S --needed --noconfirm sddm
fi

# Устанавливаем зависимости для Qt6 тем
show_info "$MSG_INSTALL_SDDM_DEPS"
sudo pacman -S --needed --noconfirm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg

# Создаем директорию для конфигов
sudo mkdir -p /etc/sddm.conf.d

# Устанавливаем тему sddm-astronaut-theme
if [[ ! -d "/usr/share/sddm/themes/sddm-astronaut-theme" ]]; then
  show_info "$MSG_INSTALL_SDDM_THEME"
  paru -S --needed --noconfirm sddm-astronaut-theme
  show_success "$MSG_SDDM_THEME_OK"
fi

# Копируем конфиг темы
if [[ -f "$VV_CONFIGS/boot/sddm.conf" ]]; then
  sudo cp "$VV_CONFIGS/boot/sddm.conf" /etc/sddm.conf.d/theme.conf
  show_success "$MSG_SDDM_CONFIG_COPIED"
fi

# Включаем SDDM service
if ! systemctl is-enabled sddm.service &>/dev/null; then
  sudo systemctl enable sddm.service
  show_success "$MSG_SDDM_SERVICE_ENABLED"
fi

show_success "$MSG_SDDM_OK"
