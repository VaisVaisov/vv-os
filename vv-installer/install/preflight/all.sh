#!/bin/bash
# Preflight checks before installation

# Language selection (runs WITHOUT logging for interactivity)
source "$VV_INSTALL/preflight/language.sh"

start_install_log

run_logged "$VV_INSTALL/preflight/check-arch.sh"
run_logged "$VV_INSTALL/preflight/check-network.sh"
run_logged "$VV_INSTALL/preflight/pacman.sh"
run_logged "$VV_INSTALL/preflight/locale-setup.sh"
