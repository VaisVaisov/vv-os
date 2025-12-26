# Auto-start VV OS installer on first TTY
if [ "$(tty)" = "/dev/tty1" ]; then
  echo ""
  echo "Starting VV OS Installer..."
  sleep 2
  /root/install-vv-os.sh
fi
