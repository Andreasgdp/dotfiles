#!/bin/zsh
# Switch to the last-focused tab in the current workspace (≈ tmux last-window).
# Stateless: herdr logs every tab.focus with workspace_id + tab_id, so the most
# recent focus event in this workspace for a tab_id != current = the tab we came
# from. Toggles because focusing emits a new event. ponytail: scans tail of
# server log; if it ever rotates mid-jump, falls back to "do nothing" rather
# than guessing.
log=/Users/anpe/.config/herdr/herdr-server.log

focused=$(herdr tab list 2>/dev/null | python3 -c 'import sys,json
try:
    tab = next((t for t in json.load(sys.stdin)["result"]["tabs"] if t["focused"]), None)
except Exception:
    tab = None
print("%s %s" % (tab["workspace_id"], tab["tab_id"]) if tab else "")')
read -r cur_ws cur <<< "$focused"

[ -n "$cur_ws" ] && [ -n "$cur" ] || exit 0

last=$(grep -o 'event="tab.focus".*tab_id="[^"]*"' "$log" \
       | grep "workspace_id=\"$cur_ws\"" \
       | grep -o 'tab_id="[^"]*"' | sed 's/tab_id="//;s/"//' \
       | awk -v cur="$cur" '$0!=cur{l=$0} END{print l}')

[ -n "$last" ] && [ "$last" != "$cur" ] && herdr tab focus "$last"
