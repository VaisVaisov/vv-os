#!/bin/bash
# VV OS Installer - Main installation script
# Based on Omarchy architecture

set -eEo pipefail

# Determine the VV OS root directory
VV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Export essential paths
export VV_ROOT
export VV_INSTALL="$VV_ROOT/install"
export VV_PACKAGES="$VV_ROOT/packages"
export VV_CONFIGS="$VV_ROOT/configs"
export VV_SCRIPTS="$VV_ROOT/scripts"
export VV_ASSETS="$VV_ROOT/assets"
export VV_LANG="$VV_ROOT/lang"
export VV_INSTALL_LOG_FILE="/var/log/vv_install_$(date '+%Y%m%d_%H%M%S').log"

# Add user bin to PATH (for custom scripts)
export PATH="$HOME/.local/bin:$PATH"

# Load English language file (only supported language)
source "$VV_LANG/en.sh"

# Welcome message
echo "${MSG_WELCOME:-Welcome to VV OS Installer}"
echo "${MSG_STARTING:-Starting installation...}"
echo ""

# Load installation modules
source "$VV_INSTALL/helpers/all.sh"
source "$VV_INSTALL/preflight/all.sh"
source "$VV_INSTALL/packaging/all.sh"
source "$VV_INSTALL/config/all.sh"
source "$VV_INSTALL/login/all.sh"
source "$VV_INSTALL/post-install/all.sh"
