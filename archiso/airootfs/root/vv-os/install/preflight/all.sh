#!/bin/bash
# Предпроверки перед установкой

# Выбор языка (запускается БЕЗ логирования для интерактивности)
source "$VV_INSTALL/preflight/language.sh"

run_logged "$VV_INSTALL/preflight/check-arch.sh"
run_logged "$VV_INSTALL/preflight/check-network.sh"
run_logged "$VV_INSTALL/preflight/pacman.sh"
