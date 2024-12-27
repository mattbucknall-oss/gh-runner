#!/bin/bash

# Build the Docker image
docker build -t gh-runner .

# Copy the runner script to the appropriate location and make it executable
cp gh-runner.sh /usr/local/bin/gh-runner.sh
chmod +x /usr/local/bin/gh-runner.sh

# Copy the systemd service file
cp gh-runner.service /etc/systemd/system/gh-runner.service

# Reload systemd daemon to register changes
systemctl daemon-reload

# Check if the service exists and stop it if it's running
if systemctl is-active --quiet gh-runner.service; then
    echo "Stopping existing gh-runner.service to apply changes..."
    systemctl stop gh-runner.service
fi

# Enable and start the service
systemctl enable gh-runner.service
systemctl start gh-runner.service
