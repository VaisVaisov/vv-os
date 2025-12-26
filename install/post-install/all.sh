#!/bin/bash
# Финальные настройки после установки

run_logged "$VV_INSTALL/post-install/swap-setup.sh"
run_logged "$VV_INSTALL/post-install/terminal-setup.sh"
run_logged "$VV_INSTALL/post-install/wallpapers.sh"
run_logged "$VV_INSTALL/post-install/avatar.sh"
run_logged "$VV_INSTALL/post-install/git-setup.sh"
run_logged "$VV_INSTALL/post-install/monitors-setup.sh"
run_logged "$VV_INSTALL/post-install/finished.sh"
