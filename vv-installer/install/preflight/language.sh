#!/bin/bash
# Installation language selection

# Always use English
VV_LANG_CU="en"

# Export language variable
export VV_LANG

# Load English localization file
source "$VV_LANG/en.sh"

# Display welcome message
clear
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║           ██╗   ██╗██╗   ██╗     ██████╗ ███████╗            ║
║           ██║   ██║██║   ██║    ██╔═══██╗██╔════╝            ║
║           ██║   ██║██║   ██║    ██║   ██║███████╗            ║
║           ╚██╗ ██╔╝╚██╗ ██╔╝    ██║   ██║╚════██║            ║
║            ╚████╔╝  ╚████╔╝     ╚██████╔╝███████║            ║
║             ╚═══╝    ╚═══╝       ╚═════╝ ╚══════╝            ║
║                                                              ║
EOF

echo "║               $MSG_WELCOME                    ║"
echo "║                                                              ║"
echo "║           $MSG_ARCH_HYPRLAND             ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
