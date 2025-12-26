#!/bin/bash
# Проверка интернет-соединения

show_info "$MSG_CHECK_NETWORK"

if ! ping -c 1 -W 3 archlinux.org &>/dev/null; then
  show_error "$MSG_NETWORK_FAIL"
  exit 1
fi

show_success "$MSG_NETWORK_OK"
