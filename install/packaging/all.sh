#!/bin/bash
# Установка всех пакетов

run_logged "$VV_INSTALL/packaging/base-system.sh"
run_logged "$VV_INSTALL/packaging/aur-helper.sh"
run_logged "$VV_INSTALL/packaging/shell-desktop.sh"
run_logged "$VV_INSTALL/packaging/system-packages.sh"
run_logged "$VV_INSTALL/packaging/gaming.sh"
run_logged "$VV_INSTALL/packaging/applications.sh"
