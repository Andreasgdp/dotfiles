#!/bin/sh
# Create a new workspace in $HOME with a random, unique label.

prefix="ws"

existing_labels() {
  herdr workspace list 2>/dev/null | jq -r '.result.workspaces[].label'
}

while :; do
  suffix=$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 6)
  label="${prefix}-${suffix}"

  if ! existing_labels | grep -Fxq "$label"; then
    exec herdr workspace create --cwd "$HOME" --label "$label" --focus
  fi
done
