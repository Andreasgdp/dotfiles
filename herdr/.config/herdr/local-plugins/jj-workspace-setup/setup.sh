#!/bin/sh
# On workspace.created: if the workspace is a secondary jj workspace,
# copy .env* files from the main repo and open the standard 5-tab layout.
set -eu

ctx=${HERDR_PLUGIN_CONTEXT_JSON:-}
ws=$(printf '%s' "$ctx" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("workspace_id",""))' 2>/dev/null || true)
cwd=$(printf '%s' "$ctx" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("workspace_cwd",""))' 2>/dev/null || true)
ws=${ws:-${HERDR_WORKSPACE_ID:-}}
[ -n "$ws" ] && [ -n "$cwd" ] || exit 0

# Secondary jj workspace: .jj/repo is a file pointing at the main repo's store.
[ -f "$cwd/.jj/repo" ] || exit 0

# Main repo root = two levels up from the .jj/repo dir the pointer names.
# The pointer may be relative to the workspace's .jj dir.
main=$(cd "$cwd/.jj" && cd "$(dirname "$(dirname "$(cat repo)")")" && pwd)

# Copy .env* files, mirroring relative paths; never overwrite.
if [ -d "$main" ]; then
  find "$main" -name '.env*' -type f \
    -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/.jj/*' |
  while IFS= read -r src; do
    rel=${src#"$main"/}
    dest="$cwd/$rel"
    [ -e "$dest" ] && continue
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
  done
fi

# 5-tab layout, same commands as the herdr-plus project templates.
# tab-index-labels prefixes the numbers, so labels are bare names.
sleep 0.2

first=$(herdr tab list --workspace "$ws" | python3 -c 'import json,sys; t=json.load(sys.stdin)["result"]["tabs"]; print(t[0]["tab_id"] if t else "")' 2>/dev/null || true)
if [ -n "$first" ]; then
  herdr tab rename "$first" "Editor" || true
  pane=$(herdr pane list --workspace "$ws" | python3 -c "
import json,sys
panes=json.load(sys.stdin)['result']['panes']
print(next((p['pane_id'] for p in panes if p['tab_id']=='$first'),''))" 2>/dev/null || true)
  [ -n "$pane" ] && herdr pane run "$pane" "nvim" || true
fi

for spec in "Server:" "AI:omp" "Version Control:jjui" "Terminal:"; do
  label=${spec%:*}
  cmd=${spec##*:}
  out=$(herdr tab create --workspace "$ws" --cwd "$cwd" --label "$label" --no-focus)
  if [ -n "$cmd" ]; then
    pane=$(printf '%s' "$out" | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["root_pane"]["pane_id"])' 2>/dev/null || true)
    [ -n "$pane" ] && herdr pane run "$pane" "$cmd" || true
  fi
done
