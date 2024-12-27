#!/bin/bash
set -e

# Check personal access token has been provided
if [ -z "$GH_PERSONAL_ACCESS_TOKEN" ]; then
    echo "Error: GH_PERSONAL_ACCESS_TOKEN not provided"
    exit 1
fi

# Check organization has been provided
if [ -z "$GH_ORG" ]; then
    echo "Error: GH_ORG not provided"
    exit 1
fi

# Organization
GH_ORG_URL=https://github.com/$GH_ORG

# Create new runner token
GH_RUNNER_TOKEN=$(curl -s -X POST \
  -H "Authorization: Bearer $GH_PERSONAL_ACCESS_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/orgs/$GH_ORG/actions/runners/registration-token" | jq -r .token)

if [ -z "$GH_RUNNER_TOKEN" ]; then
    echo "Error: Failed to retrieve runner registration token."
    exit 1
fi

unset GH_PERSONAL_ACCESS_TOKEN

# Register the runner
./config.sh --url "$GH_ORG_URL" --token "$GH_RUNNER_TOKEN" --unattended --name "$(hostname)" --work "_work"

# Ensure cleanup happens on exit
cleanup() {
  echo "Removing runner registration..."
  ./config.sh remove --token "$GH_RUNNER_TOKEN"
  unset GH_RUNNER_TOKEN
}

trap cleanup EXIT

# Listen for job in clean environment (container terminates once job completes)
sudo -u ghr -i ./run.sh --once
