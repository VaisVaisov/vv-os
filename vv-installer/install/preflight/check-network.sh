#!/bin/bash
# Check internet connectivity

show_info "$MSG_CHECK_NETWORK"

if curl -s https://archlinux.org > /dev/null 2>&1 || \
    curl -s https://google.com > /dev/null 2>&1; then
  show_success "$MSG_NETWORK_OK"
  return 0
fi

show_error "$MSG_NETWORK_FAIL"
