#!/bin/bash
# Система логирования (адаптировано из Omarchy)

start_install_log() {
  sudo touch "$VV_INSTALL_LOG_FILE"
  sudo chmod 666 "$VV_INSTALL_LOG_FILE"

  export VV_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

  echo "=== VV Builder Installation Started: $VV_START_TIME ===" >> "$VV_INSTALL_LOG_FILE"
}

stop_install_log() {
  if [[ -n ${VV_INSTALL_LOG_FILE:-} ]]; then
    VV_END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=== VV Builder Installation Completed: $VV_END_TIME ===" >> "$VV_INSTALL_LOG_FILE"

    if [ -n "$VV_START_TIME" ]; then
      VV_START_EPOCH=$(date -d "$VV_START_TIME" +%s)
      VV_END_EPOCH=$(date -d "$VV_END_TIME" +%s)
      VV_DURATION=$((VV_END_EPOCH - VV_START_EPOCH))

      VV_MINS=$((VV_DURATION / 60))
      VV_SECS=$((VV_DURATION % 60))

      echo "Installation time: ${VV_MINS}m ${VV_SECS}s" >> "$VV_INSTALL_LOG_FILE"
    fi
  fi
}

run_logged() {
  local script="$1"

  export CURRENT_SCRIPT="$script"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script" >> "$VV_INSTALL_LOG_FILE"

  bash -c "source '$script'" </dev/null >> "$VV_INSTALL_LOG_FILE" 2>&1

  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script" >> "$VV_INSTALL_LOG_FILE"
    unset CURRENT_SCRIPT
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)" >> "$VV_INSTALL_LOG_FILE"
  fi

  return $exit_code
}
