#!/bin/bash
# Install user dotfiles

show_info "$MSG_SETUP_DOTFILES"

# Copy .zshrc
if [[ -f "$VV_CONFIGS/dotfiles/.zshrc" ]]; then
  cp "$VV_CONFIGS/dotfiles/.zshrc" ~/
fi

# Copy .p10k.zsh
if [[ -f "$VV_CONFIGS/dotfiles/.p10k.zsh" ]]; then
  cp "$VV_CONFIGS/dotfiles/.p10k.zsh" ~/
fi

# Copy .gitconfig
if [[ -f "$VV_CONFIGS/dotfiles/.gitconfig" ]]; then
  cp "$VV_CONFIGS/dotfiles/.gitconfig" ~/
fi

# Copy bat config
if [[ -f "$VV_CONFIGS/dotfiles/bat/config" ]]; then
  mkdir -p ~/.config/bat
  cp "$VV_CONFIGS/dotfiles/bat/config" ~/.config/bat/
fi

# Copy foot config
if [[ -f "$VV_CONFIGS/dotfiles/foot/foot.ini" ]]; then
  mkdir -p ~/.config/foot
  cp "$VV_CONFIGS/dotfiles/foot/foot.ini" ~/.config/foot/
fi

show_success "$MSG_DOTFILES_OK"
