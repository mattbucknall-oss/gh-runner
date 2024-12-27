#!/bin/bash
docker build -t gh-runner .
cp run.sh /usr/local/bin/run.sh
chmod +x /usr/local/bin/run.sh
cp gh-runner.service /etc/systemd/system/gh-runner.service
systemctl daemon-reload
systemctl enable gh-runner.service
systemctl start gh-runner.service
