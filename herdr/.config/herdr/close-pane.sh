#!/bin/sh
# Close the focused pane. If it is the last pane in the workspace, focus the
# previously focused workspace after closing so Herdr lands there.

log="${HOME}/.config/herdr/herdr-server.log"
sync_tab_labels="${HOME}/.config/herdr/sync-tab-labels.sh"

panes=$(herdr pane list 2>/dev/null) || exit 0
focused=$(
  printf '%s\n' "$panes" | jq -r '.result.panes[] | select(.focused) | [.pane_id, .workspace_id] | @tsv' | head -n1
)
[ -n "$focused" ] || exit 0

pane_id=$(printf '%s\n' "$focused" | awk -F '\t' '{print $1}')
workspace_id=$(printf '%s\n' "$focused" | awk -F '\t' '{print $2}')
pane_count=$(printf '%s\n' "$panes" | jq -r --arg ws "$workspace_id" \
  '[.result.panes[] | select(.workspace_id == $ws)] | length')

if [ "$pane_count" -le 1 ]; then
  workspaces=$(herdr workspace list 2>/dev/null) || workspaces=
  valid_file=$(mktemp "${TMPDIR:-/tmp}/herdr-valid-workspaces.XXXXXX") || exit 1
  trap 'rm -f "$valid_file"' EXIT HUP INT TERM

  printf '%s\n' "$workspaces" | jq -r --arg ws "$workspace_id" \
    '.result.workspaces[] | select(.workspace_id != $ws) | .workspace_id' > "$valid_file"

  target=$(
    grep -o 'event="workspace.focus".*workspace_id="[^"]*"' "$log" 2>/dev/null \
      | grep -o 'workspace_id="[^"]*"' \
      | sed 's/workspace_id="//;s/"//' \
      | awk '
        NR == FNR { valid[$0] = 1; next }
        valid[$0] { last = $0 }
        END { print last }
      ' "$valid_file" -
  )

  herdr pane close "$pane_id" || exit $?

  if [ -n "$target" ]; then
    i=0
    while [ "$i" -lt 20 ]; do
      if ! herdr workspace list 2>/dev/null | jq -e --arg ws "$workspace_id" \
        '.result.workspaces[] | select(.workspace_id == $ws)' >/dev/null; then
        break
      fi
      sleep 0.05
      i=$((i + 1))
    done
    herdr workspace focus "$target" >/dev/null 2>&1
  fi

  "$sync_tab_labels" >/dev/null 2>&1 || true

  exit 0
fi

herdr pane close "$pane_id" || exit $?
sleep 0.15
"$sync_tab_labels" >/dev/null 2>&1 || true
