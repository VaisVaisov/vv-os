#!/bin/bash
# Настройка bootloader и display manager

run_logged "$VV_INSTALL/login/grub.sh"
run_logged "$VV_INSTALL/login/plymouth.sh"
run_logged "$VV_INSTALL/login/sddm.sh"
