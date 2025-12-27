#!/bin/bash
# Копирование .desktop файлов

show_info "Установка VV приложений (.desktop файлы)..."

# Копируем .desktop файлы в ~/.local/share/applications
mkdir -p ~/.local/share/applications

if [[ -d "$VV_CONFIGS/applications" ]]; then
  # Копируем все .desktop файлы
  for desktop_file in "$VV_CONFIGS/applications"/*.desktop; do
    if [[ -f "$desktop_file" ]]; then
      cp "$desktop_file" ~/.local/share/applications/
      show_success "Установлен: $(basename "$desktop_file")"
    fi
  done

  # Обновляем базу данных приложений
  if command -v update-desktop-database &>/dev/null; then
    update-desktop-database ~/.local/share/applications
  fi

  show_success "VV приложения установлены"
else
  show_info "Папка с приложениями не найдена, пропускаем"
fi
