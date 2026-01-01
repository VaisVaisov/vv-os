#!/bin/bash
# Configure Material 3 theming (matugen)

show_info "$MSG_SETUP_MATUGEN"

# Copy matugen config
mkdir -p ~/.config/matugen
cp -R "$VV_CONFIGS/matugen/"* ~/.config/matugen/

# Rebuild bat cache (if bat is installed)
if command -v bat &>/dev/null; then
  bat cache --build &>/dev/null || true
fi

show_success "$MSG_MATUGEN_OK"
