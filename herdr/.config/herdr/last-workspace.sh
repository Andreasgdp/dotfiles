#!/bin/sh
# Toggle to the "last" workspace. herdr has no native last-workspace action,
# so we self-track: focus the stored id, then store where we came from.
# ponytail: perfect for bouncing between two workspaces via this key; if you
# switch by other means in between, target falls back to first non-focused.
state="${TMPDIR:-/tmp}/herdr-last-workspace"

list=$(herdr workspace list)
cur=$(printf '%s' "$list" | jq -r '.result.workspaces[] | select(.focused) | .workspace_id')
prev=$(cat "$state" 2>/dev/null)

# valid stored target = exists and isn't the current one
target=$(printf '%s' "$list" | jq -r --arg p "$prev" --arg c "$cur" \
  '.result.workspaces[] | select(.workspace_id==$p and $p!=$c) | .workspace_id' | head -n1)
# fallback: first workspace that isn't current
[ -n "$target" ] || target=$(printf '%s' "$list" | jq -r --arg c "$cur" \
  '.result.workspaces[] | select(.workspace_id!=$c) | .workspace_id' | head -n1)

[ -n "$target" ] || exit 0
herdr workspace focus "$target"
printf '%s' "$cur" > "$state"
