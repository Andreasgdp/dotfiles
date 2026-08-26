#!/bin/sh
# sesh-style workspace picker for herdr: fuzzy-pick a dir, then focus an
# existing workspace with that name or create a new 5-tab default workspace
# rooted there.
# Open workspaces are first-class candidates, searchable by label, and shown
# first with a dot marker.

if [ "$1" = "--rank-candidates" ]; then
  query=$2
  candidate_file=$3

  awk -v query="$query" '
    BEGIN { FS = "\t"; q = tolower(query) }
    {
      kind = $1
      workspace_id = $2
      label = $3
      path = $4
      score = rank(tolower(label " " path), q)
      if (score < 0) next

      match_class = score >= 10000 ? 1 : 0
      marker = kind == "workspace" ? "●" : " "
      group = kind == "workspace" ? 0 : 1
      printf "%d\t%d\t%d\t%d\t%s\t%s\t%s\t%s\t%s\n", match_class, group, score, ++seq, marker, label, path, workspace_id, kind
    }

    function rank(text, q, pos, i, c, found, first, last) {
      if (q == "") return 0

      pos = index(text, q)
      if (pos > 0) return pos

      found = 1
      for (i = 1; i <= length(q); i++) {
        c = substr(q, i, 1)
        pos = index(substr(text, found), c)
        if (pos == 0) return -1
        found += pos
        if (i == 1) first = found - 1
        last = found - 1
      }

      return 10000 + (last - first)
    }

  ' "$candidate_file" | sort -t '	' -k1,1n -k2,2n -k3,3n -k4,4n
  exit 0
fi

create_tab() {
  workspace_id=$1
  cwd=$2
  label=$3
  command=$4

  tab_json=$(herdr tab create --workspace "$workspace_id" --cwd "$cwd" --label "$label" --no-focus)
  tab_id=$(printf '%s\n' "$tab_json" | jq -r '.result.tab.tab_id // empty')
  pane_id=$(printf '%s\n' "$tab_json" | jq -r '.result.root_pane.pane_id // empty')
  [ -n "$tab_id" ] || return 1

  if [ -n "$command" ]; then
    [ -n "$pane_id" ] && herdr pane run "$pane_id" "$command" >/dev/null
  fi
}

create_default_workspace() {
  dir=$1
  label=$2

  workspace_json=$(herdr workspace create --cwd "$dir" --label "$label" --focus)
  workspace_id=$(printf '%s\n' "$workspace_json" | jq -r '.result.workspace.workspace_id // empty')
  editor_tab=$(printf '%s\n' "$workspace_json" | jq -r '.result.tab.tab_id // empty')
  editor_pane=$(printf '%s\n' "$workspace_json" | jq -r '.result.root_pane.pane_id // empty')
  [ -n "$workspace_id" ] || exit 1

  if [ -n "$editor_tab" ]; then
    herdr tab rename "$editor_tab" "1 Editor" >/dev/null
    [ -n "$editor_pane" ] && herdr pane run "$editor_pane" "nvim" >/dev/null
  fi

  create_tab "$workspace_id" "$dir" "2 Server" ""
  create_tab "$workspace_id" "$dir" "3 AI" "omp"
  create_tab "$workspace_id" "$dir" "4 Version Control" "jjui"
  create_tab "$workspace_id" "$dir" "5 Terminal" ""

  [ -n "$editor_tab" ] && herdr tab focus "$editor_tab" >/dev/null
}

candidate_file=$(mktemp "${TMPDIR:-/tmp}/herdr-workspaces.XXXXXX") || exit 1
workspace_file=$(mktemp "${TMPDIR:-/tmp}/herdr-workspace-list.XXXXXX") || exit 1
pane_file=$(mktemp "${TMPDIR:-/tmp}/herdr-pane-list.XXXXXX") || exit 1
trap 'rm -f "$candidate_file" "$workspace_file" "$pane_file"' EXIT HUP INT TERM

herdr workspace list 2>/dev/null > "$workspace_file" || printf '{"result":{"workspaces":[]}}\n' > "$workspace_file"
herdr pane list 2>/dev/null > "$pane_file" || printf '{"result":{"panes":[]}}\n' > "$pane_file"

jq -rs '
  (.[1].result.panes
    | group_by(.workspace_id)
    | map({key: .[0].workspace_id, value: (.[0].foreground_cwd // .[0].cwd // "")})
    | from_entries) as $cwd
  | .[0].result.workspaces[]
  | ["workspace", .workspace_id, .label, ($cwd[.workspace_id] // "")]
  | @tsv
' "$workspace_file" "$pane_file" > "$candidate_file"

{
  zoxide query -l 2>/dev/null
  fd -H -d 2 -t d -E .Trash . "$HOME" 2>/dev/null
} | awk '
  BEGIN { FS = OFS = "\t" }
  NR == FNR { active_path[$4] = 1; next }
  {
    sub(/\/+$/, "")
    if ($0 != "" && !seen[$0]++ && !active_path[$0]) {
      n = split($0, parts, "/")
      print "dir", "", parts[n], $0
    }
  }
' "$candidate_file" - >> "$candidate_file"

row=$(
  "$0" --rank-candidates "" "$candidate_file" | fzf \
    --disabled --delimiter '\t' --with-nth '5,6,7' \
    --border-label ' workspace ' --prompt '⚡  ' \
    --preview 'sh -c '"'"'if [ -d "$1" ]; then ls -la "$1"; else printf "%s\n" "$2"; fi'"'"' sh {7} {6}' \
    --preview-window 'right:55%' \
    --bind "change:reload($0 --rank-candidates {q} $candidate_file)"
) || exit 0
[ -n "$row" ] || exit 0

workspace_id=$(printf '%s\n' "$row" | awk -F '\t' '{print $8}')
dir=$(printf '%s\n' "$row" | awk -F '\t' '{print $7}')

if [ -n "$workspace_id" ]; then
  herdr workspace focus "$workspace_id"
  exit $?
fi

[ -n "$dir" ] || exit 0

label=$(basename "$dir")
id=$(herdr workspace list | jq -r --arg l "$label" \
  '.result.workspaces[] | select(.label==$l) | .workspace_id' | head -n1)

if [ -n "$id" ]; then
  herdr workspace focus "$id"
else
  create_default_workspace "$dir" "$label"
fi
