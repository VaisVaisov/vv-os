#!/bin/bash
# Настройка терминала (oh-my-zsh + powerlevel10k)

show_info "$MSG_SETUP_TERMINAL"

# Устанавливаем oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  show_info "$MSG_INSTALL_OHMYZSH"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  show_success "$MSG_OHMYZSH_EXISTS"
fi

# Устанавливаем powerlevel10k
if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
  show_info "$MSG_INSTALL_P10K"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
else
  show_success "$MSG_P10K_EXISTS"
fi

# Применяем .zshrc и .p10k.zsh из dotfiles (они уже скопированы в config/dotfiles.sh)
# Проверяем что ZSH_THEME установлена на powerlevel10k
if [[ -f ~/.zshrc ]]; then
  if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
  fi
fi

# Устанавливаем zsh как shell по умолчанию
if [[ "$SHELL" != "$(which zsh)" ]]; then
  show_info "$MSG_SET_DEFAULT_SHELL"
  chsh -s "$(which zsh)"
  show_success "$MSG_SHELL_SET"
fi

show_success "$MSG_TERMINAL_OK"
