#!/bin/bash
# VV OS Auto-installer для Live ISO

clear
cd /root/vv-os || exit 1

# Запускаем VV live installer
exec ./vv-live-installer.sh
