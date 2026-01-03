#!/bin/bash
# Configure Noctalia Shell

show_info "$MSG_SETUP_NOCTALIA"

# Copy config files to user's home
mkdir -p "$VV_USER_HOME/.config/noctalia"
cp -R "$VV_CONFIGS/noctalia/"* "$VV_USER_HOME/.config/noctalia/"

# Enable user templates
if [[ -f "$VV_USER_HOME/.config/noctalia/settings.json" ]]; then
  jq '.templates.enableUserTemplates = true |
      .templates.foot = true |
      .templates.gtk = true' \
    "$VV_USER_HOME/.config/noctalia/settings.json" > "$VV_USER_HOME/.config/noctalia/settings.json.tmp"
  mv "$VV_USER_HOME/.config/noctalia/settings.json.tmp" "$VV_USER_HOME/.config/noctalia/settings.json"
fi

chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.config/noctalia"

show_success "$MSG_NOCTALIA_OK"
