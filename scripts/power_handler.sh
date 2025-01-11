#!/bin/bash

LOG_FILE="/tmp/power_handler.log"
exec >> "$LOG_FILE" 2>&1

echo "Power event detected at $(date)"

# Check different possible AC adapter locations
for adapter in /sys/class/power_supply/{AC,ADP1}/online; do
    if [ -f "$adapter" ]; then
        AC_STATUS=$(cat "$adapter")
        break
    fi
done

if [ -z "$AC_STATUS" ]; then
    echo "Could not find AC adapter status"
    exit 1
fi

if [ "$AC_STATUS" = "1" ]; then
    echo "AC adapter plugged in"
    systemctl --user start battery_notification
else
    echo "AC adapter unplugged"
    systemctl --user stop battery_notification
fi