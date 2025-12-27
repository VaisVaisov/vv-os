#!/bin/bash
# Настройка Git

show_info "$MSG_SETUP_GIT"

# Спрашиваем пользователя хочет ли настроить Git
if ! gum confirm "$MSG_CONFIRM_GIT"; then
  show_info "$MSG_SKIP_GIT"
  return 0
fi

# Запрашиваем данные
show_info "$MSG_ENTER_GIT_DATA"
GIT_NAME=$(gum input --placeholder "$MSG_GIT_NAME_PROMPT")
GIT_EMAIL=$(gum input --placeholder "$MSG_GIT_EMAIL_PROMPT")

# Настраиваем git config
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor "nvim"

show_success "$MSG_GIT_OK (name: $GIT_NAME, email: $GIT_EMAIL)"
