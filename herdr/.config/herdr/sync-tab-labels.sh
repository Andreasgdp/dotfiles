#!/bin/sh
# Prefix visible tab labels with their current index inside each workspace.

herdr tab list 2>/dev/null | python3 -c '
import json
import re
import subprocess
import sys

try:
    tabs = json.load(sys.stdin)["result"]["tabs"]
except Exception:
    sys.exit(0)

prefix = re.compile(r"^\s*\d+\s+")
workspace_counts = {}

for tab in tabs:
    workspace_id = tab.get("workspace_id", "")
    tab_id = tab.get("tab_id", "")
    label = tab.get("label", "")
    if not workspace_id or not tab_id:
        continue
    workspace_counts[workspace_id] = workspace_counts.get(workspace_id, 0) + 1
    number = str(workspace_counts[workspace_id])
    base = prefix.sub("", label).strip() or number
    wanted = number if base == number else f"{number} {base}"
    if label == wanted:
        continue
    subprocess.run(["herdr", "tab", "rename", tab_id, wanted], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
'
