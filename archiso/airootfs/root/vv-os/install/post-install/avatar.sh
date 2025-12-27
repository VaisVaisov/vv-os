#!/bin/bash
# Установка аватара пользователя

show_info "$MSG_SETUP_AVATAR"

# Проверяем наличие .face файла
if [[ -f "$VV_ASSETS/avatar/.face" ]]; then
  # Копируем .face в домашнюю директорию
  cp "$VV_ASSETS/avatar/.face" ~/.face

  # Создаем .face.icon симлинк (используется некоторыми display managers)
  ln -sf ~/.face ~/.face.icon

  show_success "$MSG_AVATAR_INSTALLED"
else
  show_info "$MSG_AVATAR_NOT_FOUND"
fi
