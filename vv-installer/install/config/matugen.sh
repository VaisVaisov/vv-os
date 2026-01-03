#!/bin/bash
# Configure Material 3 theming (matugen)

show_info "$MSG_SETUP_MATUGEN"

# Copy matugen config
mkdir -p $VV_USER_HOME/.config/matugen
cp -R "$VV_CONFIGS/matugen/"* $VV_USER_HOME/.config/matugen/

# Rebuild bat cache (if bat is installed)
if command -v bat &>/dev/null; then
  bat cache --build &>/dev/null || true
fi

# Fix ownership
chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.local" "$VV_USER_HOME/.config" 2>/dev/null || true

show_success "$MSG_MATUGEN_OK"
