#!/bin/bash
# Configure monitors for Hyprland

show_info "$MSG_SETUP_MONITORS"

# Ask user if they want to configure monitors now
if ! gum confirm "$MSG_CONFIRM_MONITORS"; then
  show_info "$MSG_SKIP_MONITORS"
  return 0
fi

# Ask for number of monitors
MONITOR_COUNT=$(gum choose --header "$MSG_HOW_MANY_MONITORS" \
  "$MSG_ONE_MONITOR" \
  "$MSG_TWO_MONITORS" \
  "$MSG_THREE_MONITORS")

case "$MONITOR_COUNT" in
  "$MSG_ONE_MONITOR")
    # Single monitor - simple configuration
    show_info "$MSG_CREATING_SINGLE_MONITOR"

    cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (single monitor)
# Auto-detection is used
monitor=,preferred,auto,1
EOF

    show_success "$MSG_SINGLE_MONITOR_CREATED"
    ;;

  "$MSG_TWO_MONITORS")
    # Dual monitors - ask for layout
    LAYOUT=$(gum choose --header "$MSG_MONITORS_LAYOUT" \
      "$MSG_LAYOUT_HORIZONTAL" \
      "$MSG_LAYOUT_VERTICAL")

    show_info "$MSG_CREATING_DUAL_MONITOR"

    if [[ "$LAYOUT" == "$MSG_LAYOUT_HORIZONTAL" ]]; then
      cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (dual horizontal)
# IMPORTANT: Replace DP-1 and DP-2 with actual monitor names (hyprctl monitors)

# Left monitor
monitor=DP-1,preferred,0x0,1

# Right monitor (to the right of the first)
monitor=DP-2,preferred,1920x0,1

# Fallback for other monitors
monitor=,preferred,auto,1
EOF
    else
      cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (dual vertical)
# IMPORTANT: Replace DP-1 and DP-2 with actual monitor names (hyprctl monitors)

# Top monitor
monitor=DP-1,preferred,0x0,1

# Bottom monitor (below the first)
monitor=DP-2,preferred,0x1080,1

# Fallback for other monitors
monitor=,preferred,auto,1
EOF
    fi

    show_success "$MSG_DUAL_MONITOR_CREATED"
    echo ""
    show_info "$MSG_IMPORTANT_AFTER_BOOT"
    show_info "$MSG_REPLACE_MONITOR_NAMES"
    ;;

  "$MSG_THREE_MONITORS")
    # Three+ monitors - create template
    show_info "$MSG_CREATING_MULTI_MONITOR"

    cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (multi-monitor template)
# IMPORTANT: Configure manually after first Hyprland launch
# Use 'hyprctl monitors' to get monitor list

# Example:
# monitor=DP-1,1920x1080@60,0x0,1          # Left
# monitor=DP-2,1920x1080@60,1920x0,1       # Center
# monitor=DP-3,1920x1080@60,3840x0,1       # Right

# Temporary auto-configuration
monitor=,preferred,auto,1

# After monitor setup, run: hyprctl reload
EOF

    show_success "$MSG_MULTI_MONITOR_CREATED"
    echo ""
    show_info "$MSG_CONFIGURE_MANUALLY"
    show_info "$MSG_AFTER_FIRST_LAUNCH"
    ;;
esac

show_success "$MSG_MONITORS_SETUP_COMPLETE"
