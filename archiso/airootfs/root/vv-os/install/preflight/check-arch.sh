#!/bin/bash
# Проверка что система - Arch Linux

show_info "$MSG_CHECK_ARCH"

if [[ ! -f /etc/arch-release ]]; then
  show_error "$MSG_ARCH_FAIL"
  exit 1
fi

show_success "$MSG_ARCH_OK"
