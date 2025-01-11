#!/bin/bash

echo "Installing Battery Notification System..."

# Create necessary directories
sudo mkdir -p /usr/local/bin
mkdir -p ~/.config/systemd/user

# Copy scripts
sudo cp scripts/battery_notification.sh /usr/local/bin/
sudo cp scripts/power_handler.sh /usr/local/bin/

# Make scripts executable
sudo chmod +x /usr/local/bin/battery_notification.sh
sudo chmod +x /usr/local/bin/power_handler.sh

# Copy udev rule
sudo cp config/99-battery_notification.rules /etc/udev/rules.d/

# Copy systemd service
cp config/battery_notification.service ~/.config/systemd/user/

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Reload systemd
systemctl --user daemon-reload
systemctl --user enable battery_notification

echo "Installation complete!"
echo "The service will start automatically when you plug in your charger."