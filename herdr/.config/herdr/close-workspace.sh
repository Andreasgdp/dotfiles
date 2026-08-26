#!/bin/sh
# Close the focused workspace after switching to the previously focused one.

log="${HOME}/.config/herdr/herdr-server.log"

list=$(herdr workspace list 2>/dev/null) || exit 0
cur=$(printf '%s\n' "$list" | jq -r '.result.workspaces[] | select(.focused) | .workspace_id' | head -n1)
[ -n "$cur" ] || exit 0

valid_file=$(mktemp "${TMPDIR:-/tmp}/herdr-valid-workspaces.XXXXXX") || exit 1
trap 'rm -f "$valid_file"' EXIT HUP INT TERM

printf '%s\n' "$list" | jq -r --arg cur "$cur" \
  '.result.workspaces[] | select(.workspace_id != $cur) | .workspace_id' > "$valid_file"

last=$(
  grep -o 'event="workspace.focus".*workspace_id="[^"]*"' "$log" 2>/dev/null \
    | grep -o 'workspace_id="[^"]*"' \
    | sed 's/workspace_id="//;s/"//' \
    | awk -v cur="$cur" '
      NR == FNR { valid[$0] = 1; next }
      $0 != cur && valid[$0] { last = $0 }
      END { print last }
    ' "$valid_file" -
)

if [ -n "$last" ]; then
  herdr workspace focus "$last" >/dev/null 2>&1 || exit 1
fi

herdr workspace close "$cur"
