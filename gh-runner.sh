#!/bin/bash

cleanup() {
    if [ -n "$CONTAINER_ID" ]; then
        docker stop "$CONTAINER_ID" || true
    fi
    
    exit 0
}

trap cleanup SIGINT SIGTERM

while true; do
  CONTAINER_ID=$(docker run --rm --env-file /etc/gh-runner-env.list -d gh-runner)
  docker wait "$CONTAINER_ID"
  sleep 1
done
