#!/bin/bash
# Настройка Material 3 theming (matugen)

show_info "$MSG_SETUP_MATUGEN"

# Копируем конфиг matugen
mkdir -p ~/.config/matugen
cp -R "$VV_CONFIGS/matugen/"* ~/.config/matugen/

# Копируем user-templates.toml
mkdir -p ~/.config/caelestia
cp "$VV_CONFIGS/matugen/user-templates.toml" ~/.config/caelestia/ 2>/dev/null || true

# Пересобираем bat кэш (если bat установлен)
if command -v bat &>/dev/null; then
  bat cache --build &>/dev/null || true
fi

show_success "$MSG_MATUGEN_OK"
