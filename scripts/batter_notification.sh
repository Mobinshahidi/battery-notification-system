#!/bin/bash

# Default configuration
CONFIG_DIR="$HOME/.config/battery_notification"
CONFIG_FILE="$CONFIG_DIR/config"
LOG_FILE="/tmp/battery_notification.log"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Load configuration or create default
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # Default settings
    cat > "$CONFIG_FILE" << EOL
# Battery notification configuration
BATTERY_PATH="/sys/class/power_supply/BAT0"
CHECK_INTERVAL=30
NOTIFY_INTERVAL=120
NOTIFICATION_URGENCY="critical"
NOTIFICATION_TITLE="Battery Fully Charged!"
NOTIFICATION_MESSAGE="Please unplug your charger to preserve battery health"
EOL
    source "$CONFIG_FILE"
fi

# Log file setup
exec > "$LOG_FILE" 2>&1
echo "Script started at $(date)"

# Environment setup
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

check_battery() {
    local status=$(cat "$BATTERY_PATH/status" 2>/dev/null)
    local capacity=$(cat "$BATTERY_PATH/capacity" 2>/dev/null)
    
    echo "Current status: $status, Capacity: $capacity"
    
    if [ "$status" = "Charging" ] && [ "$capacity" = "100" ]; then
        return 0
    else
        return 1
    fi
}

send_notification() {
    notify-send -u "$NOTIFICATION_URGENCY" \
        "$NOTIFICATION_TITLE" \
        "$NOTIFICATION_MESSAGE"
    echo "Notification sent at $(date)"
}

main_loop() {
    while true; do
        if check_battery; then
            send_notification
            sleep "$NOTIFY_INTERVAL"
        else
            sleep "$CHECK_INTERVAL"
        fi
    done
}

main_loop