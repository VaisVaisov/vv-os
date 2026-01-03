#!/bin/bash
# Install user dotfiles

show_info "$MSG_SETUP_DOTFILES"

# Copy .zshrc
if [[ -f "$VV_CONFIGS/dotfiles/.zshrc" ]]; then
  cp "$VV_CONFIGS/dotfiles/.zshrc" "$VV_USER_HOME/"
fi

# Copy .p10k.zsh
if [[ -f "$VV_CONFIGS/dotfiles/.p10k.zsh" ]]; then
  cp "$VV_CONFIGS/dotfiles/.p10k.zsh" "$VV_USER_HOME/"
fi

# Copy .gitconfig
if [[ -f "$VV_CONFIGS/dotfiles/.gitconfig" ]]; then
  cp "$VV_CONFIGS/dotfiles/.gitconfig" "$VV_USER_HOME/"
fi

# Copy bat config
if [[ -f "$VV_CONFIGS/dotfiles/bat/config" ]]; then
  mkdir -p "$VV_USER_HOME/.config/bat"
  cp "$VV_CONFIGS/dotfiles/bat/config" "$VV_USER_HOME/.config/bat/"
fi

# Copy foot config
if [[ -f "$VV_CONFIGS/dotfiles/foot/foot.ini" ]]; then
  mkdir -p "$VV_USER_HOME/.config/foot"
  cp "$VV_CONFIGS/dotfiles/foot/foot.ini" "$VV_USER_HOME/.config/foot/"
fi

# Fix ownership
chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME"

show_success "$MSG_DOTFILES_OK"
