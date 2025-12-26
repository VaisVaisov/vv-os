#!/bin/bash
# Установка пользовательских скриптов

show_info "$MSG_INSTALL_SCRIPTS"

# Создаем директорию для скриптов
mkdir -p ~/.local/bin

# Копируем все vv-* скрипты
if [[ -d "$VV_SCRIPTS" ]]; then
  cp "$VV_SCRIPTS/"vv-* ~/.local/bin/ 2>/dev/null || true

  # Даем права на исполнение
  chmod +x ~/.local/bin/vv-* 2>/dev/null || true
fi

# Копируем системные скрипты
if [[ -d "$VV_CONFIGS/scripts" ]]; then
  sudo cp "$VV_CONFIGS/scripts/prime-launcher" /usr/local/bin/ 2>/dev/null || true
  sudo cp "$VV_CONFIGS/scripts/update-mirrors.sh" /usr/local/bin/ 2>/dev/null || true

  sudo chmod +x /usr/local/bin/prime-launcher 2>/dev/null || true
  sudo chmod +x /usr/local/bin/update-mirrors.sh 2>/dev/null || true
fi

# Добавляем ~/.local/bin в PATH если его там нет
# Создаём .zshrc если его нет (dotfiles.sh запустится позже и перезапишет)
touch ~/.zshrc
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Копируем .desktop файлы для Noctalia launcher
show_info "$MSG_INSTALL_DESKTOP_FILES"
mkdir -p ~/.local/share/applications

if [[ -d "$VV_CONFIGS/applications" ]]; then
  cp "$VV_CONFIGS/applications/"*.desktop ~/.local/share/applications/ 2>/dev/null || true
  chmod 644 ~/.local/share/applications/vv-*.desktop 2>/dev/null || true
fi

# Обновляем базу данных приложений
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database ~/.local/share/applications 2>/dev/null || true
fi

show_success "$MSG_SCRIPTS_INSTALLED"
