#!/bin/zsh
# Автоматическое обновление mirrorlist через rate-mirrors

LOG_FILE="/var/log/update-mirrors.log"
BACKUP_DIR="/etc/pacman.d/mirrorlist.d"
USER="${SUDO_USER:-$USER}"

# Создаём директорию для бэкапов если её нет
mkdir -p "$BACKUP_DIR"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Начинаю обновление зеркал..." | tee -a "$LOG_FILE"

# Запускаем rate-mirrors от обычного пользователя (не от root!)
if sudo -u "$USER" rate-mirrors --save=/tmp/mirrorlist-new arch --max-delay=21600 >> "$LOG_FILE" 2>&1; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] rate-mirrors завершён успешно" | tee -a "$LOG_FILE"

    # Делаем бэкап текущего mirrorlist
    cp /etc/pacman.d/mirrorlist "$BACKUP_DIR/mirrorlist.backup-$(date +'%Y%m%d-%H%M%S')"

    # Применяем новый mirrorlist
    cp /tmp/mirrorlist-new /etc/pacman.d/mirrorlist

    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Mirrorlist обновлён успешно!" | tee -a "$LOG_FILE"
    
    # Оставляем только последние 5 бэкапов
    ls -t "$BACKUP_DIR"/mirrorlist.backup-* 2>/dev/null | tail -n +6 | xargs -r rm
    
    # Очищаем старые логи (оставляем последние 100 строк)
    tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
    
    # Удаляем временный файл
    rm -f /tmp/mirrorlist-new
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ОШИБКА: rate-mirrors завершился с ошибкой" | tee -a "$LOG_FILE"
    exit 1
fi
