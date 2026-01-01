#!/bin/bash
# Configure bootloader and display manager

run_logged "$VV_INSTALL/login/grub.sh"
run_logged "$VV_INSTALL/login/plymouth.sh"
run_logged "$VV_INSTALL/login/sddm.sh"
