#!/bin/bash

set -euo pipefail

DOTFILES_ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
MANIFEST_ROOT="$DOTFILES_ROOT/install-scripts/manifests"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)}"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

say() {
  printf '%s\n' "$*"
}

warn() {
  printf 'Warning: %s\n' "$*" >&2
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

confirm() {
  local prompt=$1
  local default=${2:-N}
  local reply

  if [[ ! -t 0 ]]; then
    [[ $default == "Y" ]]
    return
  fi

  if [[ $default == "Y" ]]; then
    read -r -p "$prompt [Y/n] " reply
    [[ -z $reply || $reply =~ ^[Yy]$ ]]
  else
    read -r -p "$prompt [y/N] " reply
    [[ $reply =~ ^[Yy]$ ]]
  fi
}

detect_platform() {
  case "$(uname -s)" in
    Darwin)
      printf 'macos\n'
      ;;
    Linux)
      printf 'linux-omarchy\n'
      ;;
    *)
      printf 'unknown\n'
      ;;
  esac
}

read_manifest() {
  local manifest=$1

  [[ -f $manifest ]] || return 0

  while IFS= read -r line || [[ -n $line ]]; do
    line=${line%%#*}
    line=${line##+([[:space:]])}
    line=${line%%+([[:space:]])}
    [[ -n $line ]] && printf '%s\n' "$line"
  done < "$manifest"
}

ensure_brew() {
  if command_exists brew; then
    return
  fi

  if ! confirm "Homebrew is missing. Install it now?" "Y"; then
    die "Homebrew is required for the macOS bootstrap."
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  command_exists brew || die "Homebrew installation did not complete successfully."
}

copy_to_clipboard() {
  local source_file=$1

  if command_exists wl-copy; then
    wl-copy < "$source_file"
  elif command_exists pbcopy; then
    pbcopy < "$source_file"
  elif command_exists xclip; then
    xclip -selection clipboard < "$source_file"
  else
    return 1
  fi
}

open_url() {
  local url=$1

  if command_exists xdg-open; then
    xdg-open "$url" >/dev/null 2>&1 &
  elif command_exists open; then
    open "$url" >/dev/null 2>&1 &
  else
    return 1
  fi
}
