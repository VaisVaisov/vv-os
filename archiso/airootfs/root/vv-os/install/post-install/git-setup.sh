#!/bin/bash
# Configure Git

show_info "$MSG_SETUP_GIT"

# Ask user if they want to configure Git
if ! gum confirm "$MSG_CONFIRM_GIT"; then
  show_info "$MSG_SKIP_GIT"
  return 0
fi

# Request user data
show_info "$MSG_ENTER_GIT_DATA"
show_info "$MSG_GIT_NAME_PROMPT"
GIT_NAME=$(gum input)
show_info "$MSG_GIT_EMAIL_PROMPT"
GIT_EMAIL=$(gum input)

# Configure git config
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global core.editor "nvim"

show_success "$MSG_GIT_OK (name: $GIT_NAME, email: $GIT_EMAIL)"
