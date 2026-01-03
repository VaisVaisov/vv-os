#!/bin/bash
# Configure terminal (oh-my-zsh + powerlevel10k)

show_info "$MSG_SETUP_TERMINAL"

# Install oh-my-zsh
if [[ ! -d $VV_USER_HOME/.oh-my-zsh ]]; then
  show_info "$MSG_INSTALL_OHMYZSH"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  show_success "$MSG_OHMYZSH_EXISTS"
fi

# Install powerlevel10k
if [[ ! -d $VV_USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
  show_info "$MSG_INSTALL_P10K"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $VV_USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k
else
  show_success "$MSG_P10K_EXISTS"
fi

# Apply .zshrc and .p10k.zsh from dotfiles (already copied in config/dotfiles.sh)
# Ensure ZSH_THEME is set to powerlevel10k
if [[ -f $VV_USER_HOME/.zshrc ]]; then
  if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' $VV_USER_HOME/.zshrc; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $VV_USER_HOME/.zshrc
  fi
fi

# Set zsh as default shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
  show_info "$MSG_SET_DEFAULT_SHELL"
  chsh -s "$(which zsh)"
  show_success "$MSG_SHELL_SET"
fi

show_success "$MSG_TERMINAL_OK"
