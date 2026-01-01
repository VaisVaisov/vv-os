#!/bin/bash
# Configure Noctalia Shell

show_info "$MSG_SETUP_NOCTALIA"

# Copy config files
mkdir -p ~/.config/noctalia
cp -R "$VV_CONFIGS/noctalia/"* ~/.config/noctalia/

# Enable user templates
if [[ -f ~/.config/noctalia/settings.json ]]; then
  jq '.templates.enableUserTemplates = true |
      .templates.foot = true |
      .templates.gtk = true' \
    ~/.config/noctalia/settings.json > ~/.config/noctalia/settings.json.tmp
  mv ~/.config/noctalia/settings.json.tmp ~/.config/noctalia/settings.json
fi

show_success "$MSG_NOCTALIA_OK"
