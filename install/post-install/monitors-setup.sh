#!/bin/bash
# Настройка мониторов для Hyprland

show_info "$MSG_SETUP_MONITORS"

# Спрашиваем пользователя, хочет ли настроить мониторы сейчас
if ! gum confirm "$MSG_CONFIRM_MONITORS"; then
  show_info "$MSG_SKIP_MONITORS"
  return 0
fi

# Спрашиваем количество мониторов
MONITOR_COUNT=$(gum choose --header "$MSG_HOW_MANY_MONITORS" \
  "$MSG_ONE_MONITOR" \
  "$MSG_TWO_MONITORS" \
  "$MSG_THREE_MONITORS")

case "$MONITOR_COUNT" in
  "$MSG_ONE_MONITOR")
    # Один монитор - простая конфигурация
    show_info "$MSG_CREATING_SINGLE_MONITOR"

    cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (single monitor)
# Используется автоопределение
monitor=,preferred,auto,1
EOF

    show_success "$MSG_SINGLE_MONITOR_CREATED"
    ;;

  "$MSG_TWO_MONITORS")
    # Два монитора - спрашиваем layout
    LAYOUT=$(gum choose --header "$MSG_MONITORS_LAYOUT" \
      "$MSG_LAYOUT_HORIZONTAL" \
      "$MSG_LAYOUT_VERTICAL")

    show_info "$MSG_CREATING_DUAL_MONITOR"

    if [[ "$LAYOUT" == "$MSG_LAYOUT_HORIZONTAL" ]]; then
      cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (dual horizontal)
# ВАЖНО: Замените DP-1 и DP-2 на реальные имена мониторов (hyprctl monitors)

# Левый монитор
monitor=DP-1,preferred,0x0,1

# Правый монитор (справа от первого)
monitor=DP-2,preferred,1920x0,1

# Fallback для других мониторов
monitor=,preferred,auto,1
EOF
    else
      cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (dual vertical)
# ВАЖНО: Замените DP-1 и DP-2 на реальные имена мониторов (hyprctl monitors)

# Верхний монитор
monitor=DP-1,preferred,0x0,1

# Нижний монитор (под первым)
monitor=DP-2,preferred,0x1080,1

# Fallback для других мониторов
monitor=,preferred,auto,1
EOF
    fi

    show_success "$MSG_DUAL_MONITOR_CREATED"
    echo ""
    show_info "$MSG_IMPORTANT_AFTER_BOOT"
    show_info "$MSG_REPLACE_MONITOR_NAMES"
    ;;

  "$MSG_THREE_MONITORS")
    # Три+ мониторов - создаем шаблон
    show_info "$MSG_CREATING_MULTI_MONITOR"

    cat > ~/.config/hypr/monitor.conf <<EOF
# Monitor configuration (multi-monitor template)
# ВАЖНО: Настройте вручную после первого запуска Hyprland
# Используйте 'hyprctl monitors' для получения списка мониторов

# Пример:
# monitor=DP-1,1920x1080@60,0x0,1          # Левый
# monitor=DP-2,1920x1080@60,1920x0,1       # Центр
# monitor=DP-3,1920x1080@60,3840x0,1       # Правый

# Временная автоконфигурация
monitor=,preferred,auto,1

# После настройки мониторов выполните: hyprctl reload
EOF

    show_success "$MSG_MULTI_MONITOR_CREATED"
    echo ""
    show_info "$MSG_CONFIGURE_MANUALLY"
    show_info "$MSG_AFTER_FIRST_LAUNCH"
    ;;
esac

show_success "$MSG_MONITORS_SETUP_COMPLETE"
