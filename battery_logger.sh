#!/bin/bash

# Battery Logger Script
# Author: kush68
# License: MIT

LOG_DIR="./battery_logs"
LOG_FILE="$LOG_DIR/battery_$(date '+%Y-%m-%d').log"
INTERVAL=120  # Interval in seconds (default: 2 minutes)

mkdir -p "$LOG_DIR"

get_battery_status() {
    if command -v acpi &>/dev/null; then
        acpi -b
    elif [ -d /sys/class/power_supply/BAT0 ]; then
        STATUS=$(cat /sys/class/power_supply/BAT0/status)
        CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
        echo "Status: $STATUS, Capacity: $CAPACITY%"
    else
        echo "Battery info not available"
    fi
}

log_battery() {
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    STATUS=$(get_battery_status)
    echo "$TIMESTAMP - $STATUS" >> "$LOG_FILE"
}

echo "[+] Battery logging started. Output: $LOG_FILE"
echo "[+] Interval: Every $INTERVAL seconds. Press Ctrl+C to stop."

while true; do
    log_battery
    sleep "$INTERVAL"
done
