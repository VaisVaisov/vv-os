#!/bin/bash
# Настройка Noctalia Shell

show_info "$MSG_SETUP_NOCTALIA"

# Копируем конфиги
mkdir -p ~/.config/noctalia
cp -R "$VV_CONFIGS/noctalia/"* ~/.config/noctalia/

# Включаем user templates
if [[ -f ~/.config/noctalia/settings.json ]]; then
  jq '.templates.enableUserTemplates = true |
      .templates.foot = true |
      .templates.gtk = true' \
    ~/.config/noctalia/settings.json > ~/.config/noctalia/settings.json.tmp
  mv ~/.config/noctalia/settings.json.tmp ~/.config/noctalia/settings.json
fi

show_success "$MSG_NOCTALIA_OK"
