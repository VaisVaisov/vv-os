#!/bin/bash
# Настройка systemd сервисов

show_info "$MSG_SETUP_SYSTEMD"

# Создаем директории для systemd
mkdir -p ~/.config/systemd/user
sudo mkdir -p /etc/systemd/system

# Копируем Noctalia service
if [[ -f "$VV_CONFIGS/systemd/noctalia.service" ]]; then
  cp "$VV_CONFIGS/systemd/noctalia.service" ~/.config/systemd/user/
fi

# Копируем override для Noctalia
if [[ -f "$VV_CONFIGS/systemd/noctalia.service.d/override.conf" ]]; then
  mkdir -p ~/.config/systemd/user/noctalia.service.d
  cp "$VV_CONFIGS/systemd/noctalia.service.d/override.conf" ~/.config/systemd/user/noctalia.service.d/
fi

# Копируем update-mirrors service и timer
if [[ -f "$VV_CONFIGS/systemd/update-mirrors.service" ]]; then
  sudo cp "$VV_CONFIGS/systemd/update-mirrors.service" /etc/systemd/system/
fi

if [[ -f "$VV_CONFIGS/systemd/update-mirrors.timer" ]]; then
  sudo cp "$VV_CONFIGS/systemd/update-mirrors.timer" /etc/systemd/system/
fi

# Копируем plymouth override
if [[ -f "$VV_CONFIGS/systemd/plymouth-quit.service.d/override.conf" ]]; then
  sudo mkdir -p /etc/systemd/system/plymouth-quit.service.d
  sudo cp "$VV_CONFIGS/systemd/plymouth-quit.service.d/override.conf" /etc/systemd/system/plymouth-quit.service.d/
fi

# Перезагружаем systemd (только вне chroot)
if [[ -z "${VV_CHROOT_INSTALL:-}" ]]; then
  systemctl --user daemon-reload
  sudo systemctl daemon-reload
fi

# Включаем Noctalia service
if [[ -n "${VV_CHROOT_INSTALL:-}" ]]; then
  # В chroot используем systemctl enable без --user (будет включен для всех пользователей)
  show_info "$MSG_ENABLE_NOCTALIA"
  # Копируем service в /etc/systemd/user/ уже сделано выше
else
  systemctl --user enable noctalia.service
fi

# Включаем update-mirrors timer
sudo systemctl enable update-mirrors.timer

show_success "$MSG_SYSTEMD_OK"
