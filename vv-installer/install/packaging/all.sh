#!/bin/bash
# Install all packages

run_logged "$VV_INSTALL/packaging/base-system.sh"
run_logged "$VV_INSTALL/packaging/system-packages.sh"
run_logged "$VV_INSTALL/packaging/aur-helper.sh"
run_logged "$VV_INSTALL/packaging/package-managers.sh"
run_logged "$VV_INSTALL/packaging/shell-desktop.sh"
run_logged "$VV_INSTALL/packaging/electron.sh"
run_logged "$VV_INSTALL/packaging/applications.sh"
run_logged "$VV_INSTALL/packaging/gaming.sh"
