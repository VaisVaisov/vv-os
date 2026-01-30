#!/bin/bash
# Setup system locale (must run before package installation)

show_info "$MSG_SETUP_LOCALE"

# List of available locales (locale_code:description)
locales=(
  "en_US:English (US)"
  "en_GB:English (UK)"
  "ru_RU:Russian"
  "de_DE:German"
  "fr_FR:French"
  "es_ES:Spanish"
  "it_IT:Italian"
  "pt_BR:Portuguese (Brazil)"
  "zh_CN:Chinese (Simplified)"
  "ja_JP:Japanese"
  "ko_KR:Korean"
)

# Always enable en_US.UTF-8 as base
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
selected_locales=("en_US.UTF-8")

# Ask user to select additional locales
show_info "$MSG_SELECT_LOCALES"
echo ""

# Build options array for gum
options=()
for locale in "${locales[@]}"; do
  code="${locale%%:*}"
  desc="${locale#*:}"
  # Skip en_US as it's already added
  if [[ "$code" != "en_US" ]]; then
    options+=("$desc ($code)")
  fi
done

# Multi-select locales
if selected=$(gum choose --no-limit "${options[@]}"); then
  while IFS= read -r line; do
    # Extract locale code from selection
    locale_code=$(echo "$line" | grep -oP '\([a-z]{2}_[A-Z]{2}\)' | tr -d '()')
    if [[ -n "$locale_code" ]]; then
      # Uncomment in /etc/locale.gen
      sed -i "s/^#${locale_code}.UTF-8 UTF-8/${locale_code}.UTF-8 UTF-8/" /etc/locale.gen
      selected_locales+=("${locale_code}.UTF-8")
      show_info "$MSG_LOCALE_ENABLED: ${locale_code}.UTF-8"
    fi
  done <<< "$selected"
fi

# Generate all selected locales
show_info "$MSG_LOCALE_GENERATING"
locale-gen

# Set system locale to en_US.UTF-8 (standard)
echo "LANG=en_US.UTF-8" > /etc/locale.conf
show_success "$MSG_LOCALE_SYSTEM_SET: en_US.UTF-8"

echo ""
show_info "$MSG_SELECT_KEYMAPS"
echo ""

# List of keyboard layouts
keymaps=(
  "us:US (QWERTY)"
  "ru:Russian"
  "de:German"
  "fr:French"
  "es:Spanish"
  "uk:UK"
  "dvorak:Dvorak"
)

# Build keymap options
keymap_options=()
for km in "${keymaps[@]}"; do
  code="${km%%:*}"
  desc="${km#*:}"
  keymap_options+=("$desc ($code)")
done

# Multi-select keymaps
selected_keymaps=("us")  # Always include US as default
if selected=$(gum choose --no-limit "${keymap_options[@]}"); then
  temp_keymaps=()
  while IFS= read -r line; do
    # Extract keymap code
    keymap_code=$(echo "$line" | grep -oP '\([a-z]+\)' | tr -d '()')
    if [[ -n "$keymap_code" ]]; then
      temp_keymaps+=("$keymap_code")
      show_info "$MSG_KEYMAP_SELECTED: $keymap_code"
    fi
  done <<< "$selected"

  # If user selected something, use it (otherwise keep 'us')
  if [[ ${#temp_keymaps[@]} -gt 0 ]]; then
    selected_keymaps=("${temp_keymaps[@]}")
  fi
fi

# Set primary keymap (first selected)
primary_keymap="${selected_keymaps[0]}"
echo "KEYMAP=$primary_keymap" > /etc/vconsole.conf
show_success "$MSG_KEYMAP_CONSOLE_SET: $primary_keymap"

# Additional keymaps will be available in Hyprland/desktop (configured by user later)
if [[ ${#selected_keymaps[@]} -gt 1 ]]; then
  show_info "$MSG_KEYMAP_ADDITIONAL: ${selected_keymaps[*]}"
  show_info "$MSG_KEYMAP_HYPRLAND_INFO"
fi

echo ""
show_success "$MSG_LOCALE_OK"
