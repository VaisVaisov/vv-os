#!/bin/bash
# UI presentation (requires gum)

# Check for gum availability
if ! command -v gum &>/dev/null; then
  echo "Installing gum for interactive UI..."
  sudo pacman -S --needed --noconfirm gum
fi

# Color scheme (Tokyo Night / Material 3)
export GUM_CONFIRM_PROMPT_FOREGROUND="6"     # Cyan
export GUM_CONFIRM_SELECTED_FOREGROUND="0"   # Black
export GUM_CONFIRM_SELECTED_BACKGROUND="2"   # Green
export GUM_CONFIRM_UNSELECTED_FOREGROUND="7" # White
export GUM_CONFIRM_UNSELECTED_BACKGROUND="0" # Black

show_header() {
  local text="$1"
  gum style --foreground 2 --bold "$text"
}

show_success() {
  local text="$1"
  gum style --foreground 2 "✓ $text"
}

show_error() {
  local text="$1"
  gum style --foreground 1 "✗ $text"
}

show_info() {
  local text="$1"
  gum style --foreground 6 "→ $text"
}
show_warning() {
  local text="$1"
  gum style --foreground 3 "⚠ $text";
}
