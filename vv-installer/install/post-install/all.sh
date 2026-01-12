#!/bin/bash
# Final post-installation setup

run_logged "$VV_INSTALL/post-install/swap-setup.sh"
run_logged "$VV_INSTALL/post-install/terminal-setup.sh"
run_logged "$VV_INSTALL/post-install/wallpapers.sh"
run_logged "$VV_INSTALL/post-install/avatar.sh"
run_logged "$VV_INSTALL/post-install/monitors-setup.sh"
run_logged "$VV_INSTALL/post-install/firewall-setup.sh"
run_logged "$VV_INSTALL/post-install/git-setup.sh"
run_logged "$VV_INSTALL/post-install/flatpak-setup.sh"
run_logged "$VV_INSTALL/post-install/snapper-setup.sh"
run_logged "$VV_INSTALL/post-install/finished.sh"

stop_install_log
