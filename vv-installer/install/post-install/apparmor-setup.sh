#!/bin/bash
# Configure AppArmor security module

show_info "$MSG_SETUP_APPARMOR"

# Check if AppArmor is installed
if ! pacman -Q apparmor &>/dev/null; then
  show_info "$MSG_INSTALL_APPARMOR"
  sudo pacman -S --noconfirm --needed apparmor
fi

# Enable AppArmor service
if ! systemctl is-enabled apparmor.service &>/dev/null; then
  show_info "$MSG_APPARMOR_ENABLE_SERVICE"
  sudo systemctl enable apparmor.service
fi

# Check if AppArmor is already in GRUB parameters
if ! grep -q "lsm=.*apparmor" /etc/default/grub; then
  show_info "$MSG_APPARMOR_ADD_KERNEL_PARAMS"

  # Add AppArmor to kernel parameters
  sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&lsm=landlock,lockdown,yama,apparmor,bpf /' /etc/default/grub

  # Regenerate GRUB config
  show_info "$MSG_APPARMOR_REGENERATE_GRUB"
  sudo grub-mkconfig -o /boot/grub/grub.cfg

  show_success "$MSG_APPARMOR_KERNEL_PARAMS_ADDED"
else
  show_success "$MSG_APPARMOR_KERNEL_PARAMS_OK"
fi

# Install AppArmor profiles collection (AUR)
show_info "$MSG_INSTALL_APPARMOR_PROFILES"

# Install apparmor.d - full set of profiles in complain mode (safe to test)
install_aur_package "apparmor.d"

cleanup_builduser

# Setup aa-notify autostart (comes with main apparmor package)
show_info "$MSG_APPARMOR_SETUP_NOTIFY"
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/apparmor-notify.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=AppArmor Notify
Comment=Desktop notifications for AppArmor DENIED messages
Exec=aa-notify -p -s 1 -w 60
X-GNOME-Autostart-enabled=true
NoDisplay=true
EOF

show_success "$MSG_APPARMOR_OK"
echo ""
show_info "$MSG_APPARMOR_CLI_UTILS"
echo "  - aa-status       : View all profiles status"
echo "  - aa-enforce <profile> : Enable profile (blocking mode)"
echo "  - aa-complain <profile> : Set to complain mode (log only)"
echo "  - aa-disable <profile> : Disable profile"
echo "  - aa-genprof <binary> : Generate new profile (interactive TUI)"
echo "  - aa-logprof      : Analyze logs and update profiles (interactive TUI)"
echo ""

# Show info message
echo ""
show_info "$MSG_APPARMOR_REBOOT_REQUIRED"
echo ""
