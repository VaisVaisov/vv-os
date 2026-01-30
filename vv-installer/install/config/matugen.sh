#!/bin/bash
# Configure Material 3 theming (matugen)

show_info "$MSG_SETUP_MATUGEN"

# Copy matugen config
mkdir -p $VV_USER_HOME/.config/matugen
cp -R "$VV_CONFIGS/matugen/"* $VV_USER_HOME/.config/matugen/

# Fix GTK symlinks created by nwg-look or other theme tools
# matugen cannot write to symlinks pointing to system files (/usr/share)
for gtk_dir in "$VV_USER_HOME/.config/gtk-3.0" "$VV_USER_HOME/.config/gtk-4.0"; do
  gtk_css="$gtk_dir/gtk.css"
  if [[ -L "$gtk_css" ]]; then
    show_info "$MSG_CONFIG_MATUGEN_REMOVE_SYMLINK: $gtk_css"
    rm -f "$gtk_css"
    mkdir -p "$gtk_dir"
    touch "$gtk_css"
    chown "$VV_USER:$VV_USER" "$gtk_css"
  fi
done

# Rebuild bat cache (if bat is installed)
if command -v bat &>/dev/null; then
  bat cache --build &>/dev/null || true
fi

# Fix ownership
chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.local" "$VV_USER_HOME/.config" 2>/dev/null || true

show_success "$MSG_MATUGEN_OK"
