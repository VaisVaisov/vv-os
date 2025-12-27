#!/bin/bash
# Копирование dotfiles

show_info "$MSG_SETUP_DOTFILES"

# Копируем .zshrc
if [[ -f "$VV_CONFIGS/dotfiles/.zshrc" ]]; then
  cp "$VV_CONFIGS/dotfiles/.zshrc" ~/
fi

# Копируем .p10k.zsh
if [[ -f "$VV_CONFIGS/dotfiles/.p10k.zsh" ]]; then
  cp "$VV_CONFIGS/dotfiles/.p10k.zsh" ~/
fi

# Копируем .gitconfig
if [[ -f "$VV_CONFIGS/dotfiles/.gitconfig" ]]; then
  cp "$VV_CONFIGS/dotfiles/.gitconfig" ~/
fi

# Копируем bat конфиг
if [[ -f "$VV_CONFIGS/dotfiles/bat/config" ]]; then
  mkdir -p ~/.config/bat
  cp "$VV_CONFIGS/dotfiles/bat/config" ~/.config/bat/
fi

# Копируем foot конфиг
if [[ -f "$VV_CONFIGS/dotfiles/foot/foot.ini" ]]; then
  mkdir -p ~/.config/foot
  cp "$VV_CONFIGS/dotfiles/foot/foot.ini" ~/.config/foot/
fi

show_success "$MSG_DOTFILES_OK"
