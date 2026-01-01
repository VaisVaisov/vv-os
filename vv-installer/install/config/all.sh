#!/bin/bash
# Copy and configure system and user configs

run_logged "$VV_INSTALL/config/hyprland.sh"
run_logged "$VV_INSTALL/config/noctalia.sh"
run_logged "$VV_INSTALL/config/matugen.sh"
run_logged "$VV_INSTALL/config/gamemode.sh"
run_logged "$VV_INSTALL/config/scripts.sh"
run_logged "$VV_INSTALL/config/systemd.sh"
run_logged "$VV_INSTALL/config/applications.sh"
run_logged "$VV_INSTALL/config/dotfiles.sh"
