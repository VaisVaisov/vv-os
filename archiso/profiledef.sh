#!/usr/bin/env bash
# VV OS archiso profile

iso_name="vv-os"
iso_label="VV_OS_$(date +%Y%m)"
iso_publisher="Vais Vaisov <https://github.com/vaisvaisov>"
iso_application="VV OS - Arch Linux with Hyprland + Noctalia Shell"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.grub.esp' 'uefi-x64.grub.esp'
           'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/root"]="0:0:750"
  ["/root/vv-live-installer.sh"]="0:0:755"
  ["/root/install-vv-os.sh"]="0:0:755"
)
