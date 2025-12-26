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

# Определение языка системы
detect_language() {
    case "$LANG" in
        ru_RU*) LANG_CODE="ru" ;;
        *)      LANG_CODE="en" ;;
    esac
    export LANG_CODE
}

# Загрузка языковых файлов
load_language() {
    if [ -f "$VV_LANG/${LANG_CODE}.sh" ]; then
        source "$VV_LANG/${LANG_CODE}.sh"
    else
        echo "Warning: Language file not found, falling back to English"
        source "$VV_LANG/en.sh"
    fi
}

# Инициализация
detect_language
load_language

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
