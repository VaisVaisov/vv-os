#!/bin/bash
# Обработка ошибок установки

# Флаг чтобы избежать рекурсивной обработки ошибок
ERROR_HANDLING=false

# Показать курсор (обычно скрыт во время установки)
show_cursor() {
  printf "\033[?25h"
}

# Показать последние строки лога
show_log_tail() {
  if [[ -f $VV_INSTALL_LOG_FILE ]]; then
    echo ""
    echo "$MSG_ERROR_LOG_TAIL"
    echo "================================"
    tail -n 20 "$VV_INSTALL_LOG_FILE"
    echo "================================"
    echo ""
  fi
}

# Показать упавшую команду или скрипт
show_failed_command() {
  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    echo "❌ $MSG_ERROR_FAILED_SCRIPT: $CURRENT_SCRIPT"
  else
    echo "❌ $MSG_ERROR_FAILED_COMMAND: $BASH_COMMAND"
  fi
}

# Обработчик ошибок
catch_errors() {
  # Предотвращаем рекурсивную обработку
  if [[ $ERROR_HANDLING == true ]]; then
    return
  fi
  ERROR_HANDLING=true

  # Сохраняем код выхода
  local exit_code=$?

  show_cursor
  echo ""
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║                                                              ║"
  echo "║              ❌ $MSG_ERROR_TITLE                            ║"
  echo "║                                                              ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo ""

  show_log_tail
  show_failed_command
  echo ""
  echo "$MSG_ERROR_EXIT_CODE: $exit_code"
  echo ""

  # Меню опций
  if command -v gum &>/dev/null; then
    while true; do
      choice=$(gum choose "$MSG_ERROR_VIEW_LOG" "$MSG_ERROR_EXIT" --header "$MSG_ERROR_WHAT_NEXT")

      case "$choice" in
        "$MSG_ERROR_VIEW_LOG")
          if command -v less &>/dev/null; then
            less "$VV_INSTALL_LOG_FILE"
          else
            cat "$VV_INSTALL_LOG_FILE"
          fi
          ;;
        "$MSG_ERROR_EXIT"|"")
          exit 1
          ;;
      esac
    done
  else
    echo "$MSG_ERROR_FULL_LOG: $VV_INSTALL_LOG_FILE"
    echo ""
    read -p "$MSG_ERROR_PRESS_ENTER"
    exit 1
  fi
}

# Обработчик выхода
exit_handler() {
  local exit_code=$?

  # Запускаем обработку ошибок только если выход с ошибкой
  if [[ $exit_code -ne 0 && $ERROR_HANDLING != true ]]; then
    catch_errors
  else
    show_cursor
  fi
}

# Устанавливаем traps
trap catch_errors ERR INT TERM
trap exit_handler EXIT
