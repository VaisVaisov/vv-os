#!/bin/bash
# Установка AUR helpers (paru + yay)

install_aur_helper() {
  local helper="$1"
  local repo="$2"

  if command -v "$helper" &>/dev/null; then
    show_success "$helper $MSG_AUR_ALREADY_INSTALLED"
    return 0
  fi

  show_info "$MSG_INSTALLING $helper..."

  cd /tmp
  git clone "https://aur.archlinux.org/${repo}.git"
  cd "$repo"
  makepkg -si --noconfirm --needed
  cd ~
  rm -rf "/tmp/$repo"

  show_success "$helper $MSG_INSTALLED"
}

# Устанавливаем оба helper'а
install_aur_helper "paru" "paru-git"
install_aur_helper "yay" "yay"
