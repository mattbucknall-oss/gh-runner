#!/bin/bash
docker build -t gh-runner .
cp gh-runner.sh /usr/local/bin/gh-runner.sh
chmod +x /usr/local/bin/gh-runner.sh
cp gh-runner.service /etc/systemd/system/gh-runner.service
systemctl daemon-reload
systemctl enable gh-runner.service
systemctl start gh-runner.service
