#!/bin/sh
set -eu

state_dir=${HERDR_PLUGIN_STATE_DIR:-/tmp/herdr-tab-index-labels}
lock_dir="$state_dir/sync.lock"
pending="$state_dir/pending"
sync_script="${HOME}/.config/herdr/sync-tab-labels.sh"

mkdir -p "$state_dir"

if ! mkdir "$lock_dir" 2>/dev/null; then
  : >"$pending"
  exit 0
fi

cleanup() {
  rmdir "$lock_dir" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

while :; do
  rm -f "$pending"
  # Let Herdr finish applying the create/close/rename before reading tab state.
  sleep 0.15
  "$sync_script" >/dev/null 2>&1 || true
  [ -e "$pending" ] || break
done
