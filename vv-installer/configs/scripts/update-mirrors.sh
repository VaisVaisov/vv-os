#!/bin/zsh
# Automatic mirrorlist update via rate-mirrors

LOG_FILE="/var/log/update-mirrors.log"
BACKUP_DIR="/etc/pacman.d/mirrorlist.d"
USER="${SUDO_USER:-$USER}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Starting mirror update..." | tee -a "$LOG_FILE"

# Run rate-mirrors as regular user (not as root!)
if sudo -u "$USER" rate-mirrors --save=/tmp/mirrorlist-new arch --max-delay=21600 >> "$LOG_FILE" 2>&1; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] rate-mirrors completed successfully" | tee -a "$LOG_FILE"

    # Backup current mirrorlist
    cp /etc/pacman.d/mirrorlist "$BACKUP_DIR/mirrorlist.backup-$(date +'%Y%m%d-%H%M%S')"

    # Apply new mirrorlist
    cp /tmp/mirrorlist-new /etc/pacman.d/mirrorlist

    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Mirrorlist updated successfully!" | tee -a "$LOG_FILE"

    # Keep only last 5 backups
    ls -t "$BACKUP_DIR"/mirrorlist.backup-* 2>/dev/null | tail -n +6 | xargs -r rm

    # Clean old logs (keep last 100 lines)
    tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"

    # Remove temporary file
    rm -f /tmp/mirrorlist-new
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: rate-mirrors failed" | tee -a "$LOG_FILE"
    exit 1
fi
