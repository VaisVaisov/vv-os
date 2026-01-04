#!/bin/bash
# Configure terminal (oh-my-zsh + powerlevel10k)

show_info "$MSG_SETUP_TERMINAL"

# Install oh-my-zsh for user
if [[ ! -d $VV_USER_HOME/.oh-my-zsh ]]; then
  show_info "$MSG_INSTALL_OHMYZSH"
  # Install oh-my-zsh as target user
  sudo -u "$VV_USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  # Fix ownership just in case
  chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.oh-my-zsh"
else
  show_success "$MSG_OHMYZSH_EXISTS"
fi

# Install powerlevel10k for user
if [[ ! -d $VV_USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
  show_info "$MSG_INSTALL_P10K"
  sudo -u "$VV_USER" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $VV_USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k
  chown -R "$VV_USER:$VV_USER" "$VV_USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k"
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

# Set zsh as default shell for user
show_info "$MSG_SET_DEFAULT_SHELL"
sudo usermod -s /bin/zsh "$VV_USER"
show_success "$MSG_SHELL_SET (user: $VV_USER)"

show_success "$MSG_TERMINAL_OK"
