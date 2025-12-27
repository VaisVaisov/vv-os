#!/bin/bash
# VV OS Installer - Главный установщик
# Основано на архитектуре Omarchy

set -eEo pipefail

# Определяем корневую директорию VV OS
VV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Экспортируем пути
export VV_ROOT
export VV_INSTALL="$VV_ROOT/install"
export VV_PACKAGES="$VV_ROOT/packages"
export VV_CONFIGS="$VV_ROOT/configs"
export VV_SCRIPTS="$VV_ROOT/scripts"
export VV_ASSETS="$VV_ROOT/assets"
export VV_LANG="$VV_ROOT/lang"
export VV_INSTALL_LOG_FILE="/var/log/vv-install.log"

# Добавляем bin в PATH (для пользовательских скриптов)
export PATH="$HOME/.local/bin:$PATH"

# Load English language file (only supported language)
source "$VV_LANG/en.sh"

# Приветствие
echo "${MSG_WELCOME:-Welcome to VV OS Installer}"
echo "${MSG_STARTING:-Starting installation...}"
echo ""

# Загружаем модули установки
source "$VV_INSTALL/helpers/all.sh"
source "$VV_INSTALL/preflight/all.sh"
source "$VV_INSTALL/packaging/all.sh"
source "$VV_INSTALL/config/all.sh"
source "$VV_INSTALL/login/all.sh"
source "$VV_INSTALL/post-install/all.sh"
