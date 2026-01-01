#!/usr/bin/env bash
# VV OS archiso profile

iso_name="vv-os"
iso_label="VV-OS"
iso_publisher="Vais Vaisov <https://github.com/vaisvaisov>"
iso_application="VV OS - Arch Linux with Hyprland + Noctalia Shell"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/root"]="0:0:750"
  ["/root/install-vv-os.sh"]="0:0:755"
  ["/root/vv-os"]="0:0:755"
  ["/root/vv-os/vv-live-installer.sh"]="0:0:755"
  ["/root/vv-os/install.sh"]="0:0:755"
  ["/root/vv-os/boot.sh"]="0:0:755"
)
