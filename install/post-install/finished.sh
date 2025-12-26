#!/bin/bash
# Финальное сообщение после установки

show_header "================================"
show_header "  $MSG_INSTALL_COMPLETE_HEADER"
show_header "================================"
echo ""

show_success "$MSG_ALL_COMPONENTS"
echo "  • Hyprland + Noctalia Shell"
echo "  • Material 3 theming (matugen)"
echo "  • GameMode"
echo ""

show_info "$MSG_NEXT_STEPS"
echo "  $MSG_STEP_REBOOT"
echo "  $MSG_STEP_SELECT_HYPRLAND"
echo "  $MSG_STEP_CHANGE_WALLPAPER"
echo "  $MSG_STEP_M3_AUTO"
echo ""

show_info "$MSG_USEFUL_COMMANDS"
echo "  • SUPER+Space - Noctalia Launcher"
echo "  • SUPER+A - Control Center"
echo "  • SUPER+C - Clipboard"
echo "  • SUPER+. - Emoji"
echo ""

show_info "$MSG_INSTALL_LOG $VV_INSTALL_LOG_FILE"
echo ""

if gum confirm "$MSG_REBOOT_NOW"; then
  show_success "$MSG_REBOOTING"
  sudo reboot
else
  show_info "$MSG_REBOOT_MANUALLY"
fi
