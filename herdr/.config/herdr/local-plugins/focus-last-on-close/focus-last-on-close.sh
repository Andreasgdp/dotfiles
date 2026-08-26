#!/bin/sh
# After any workspace closes, focus the most recent still-open workspace.

log="${HOME}/.config/herdr/herdr-server.log"
herdr_bin=${HERDR_BIN_PATH:-herdr}

closed=$(
  printf '%s\n' "${HERDR_PLUGIN_EVENT_JSON:-}" \
    | jq -r '.. | objects | .workspace_id? // empty' 2>/dev/null \
    | head -n1
)

list=$("$herdr_bin" workspace list 2>/dev/null) || exit 0

valid_file=$(mktemp "${TMPDIR:-/tmp}/herdr-valid-workspaces.XXXXXX") || exit 1
trap 'rm -f "$valid_file"' EXIT HUP INT TERM

printf '%s\n' "$list" | jq -r '.result.workspaces[].workspace_id' > "$valid_file"

target=$(
  grep -o 'event="workspace.focus".*workspace_id="[^"]*"' "$log" 2>/dev/null \
    | grep -o 'workspace_id="[^"]*"' \
    | sed 's/workspace_id="//;s/"//' \
    | awk -v closed="$closed" '
      NR == FNR { valid[$0] = 1; next }
      $0 != closed && valid[$0] { last = $0 }
      END { print last }
    ' "$valid_file" -
)

[ -n "$target" ] || exit 0
"$herdr_bin" workspace focus "$target" >/dev/null 2>&1 || true
