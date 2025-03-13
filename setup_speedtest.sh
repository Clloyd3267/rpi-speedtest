#!/bin/bash

# Configs
SERVICE_FILE="/etc/systemd/system/speedtest.service"
TIMER_FILE="/etc/systemd/system/speedtest.timer"

# Create systemd service file
echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Run Speedtest and send data to InfluxDB

[Service]
ExecStart=/home/pi/rpi-speedtest/run_speedtest.sh
User=pi
EOL

# Create systemd timer file
echo "Creating systemd timer file..."
sudo bash -c "cat > $TIMER_FILE" <<EOL
[Unit]
Description=Run Speedtest every 5 minutes

[Timer]
OnBootSec=5min
# Change this value to configure the interval
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
EOL

# Reload systemd, enable and start the timer
echo "Reloading systemd, enabling and starting the timer..."
sudo systemctl daemon-reload
sudo systemctl enable speedtest.timer
sudo systemctl start speedtest.timer