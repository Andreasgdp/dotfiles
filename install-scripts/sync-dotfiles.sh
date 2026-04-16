#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOTFILES_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

source "$DOTFILES_ROOT/install-scripts/lib/common.sh"

shopt -s dotglob extglob globstar nullglob

managed_target_for_rel() {
  local rel=$1
  local first second third rest

  IFS='/' read -r first second third rest <<< "$rel"

  if [[ -z ${second:-} ]]; then
    printf '%s/%s\n' "$HOME" "$first"
  elif [[ $first == ".config" ]]; then
    printf '%s/.config/%s\n' "$HOME" "$second"
  elif [[ $first == ".local" && -n ${third:-} ]]; then
    printf '%s/.local/%s/%s\n' "$HOME" "$second" "$third"
  elif [[ $first == .* ]]; then
    printf '%s/%s/%s\n' "$HOME" "$first" "$second"
  else
    printf '%s/%s\n' "$HOME" "$first"
  fi
}

package_targets() {
  local package=$1
  local path rel target
  declare -A seen=()

  for path in "$DOTFILES_ROOT/$package"/**; do
    [[ -f $path || -L $path ]] || continue
    rel=${path#"$DOTFILES_ROOT/$package/"}
    target=$(managed_target_for_rel "$rel")
    if [[ -n ${seen[$target]:-} ]]; then
      continue
    fi
    seen[$target]=1
    printf '%s\n' "$target"
  done
}

package_is_synced() {
  local package=$1
  local target
  local package_dir=$DOTFILES_ROOT/$package
  local saw_target=0

  while IFS= read -r target; do
    saw_target=1
    if [[ ! -L $target ]]; then
      return 1
    fi

    if [[ $(readlink -f "$target") != $package_dir* ]]; then
      return 1
    fi
  done < <(package_targets "$package")

  (( saw_target == 1 ))
}

backup_package_targets() {
  local package=$1
  local target rel destination
  local backup_dir="$BACKUP_ROOT/$package"

  mkdir -p "$backup_dir"

  while IFS= read -r target; do
    [[ -e $target || -L $target ]] || continue
    rel=${target#"$HOME/"}
    destination="$backup_dir/$rel"
    mkdir -p "$(dirname "$destination")"
    mv "$target" "$destination"
  done < <(package_targets "$package")
}

sync_package() {
  local package=$1

  if package_is_synced "$package"; then
    say "$package is already synced."
    return
  fi

  if ! confirm "Sync package '$package'?" "Y"; then
    say "Skipped $package"
    return
  fi

  if stow -n -d "$DOTFILES_ROOT" -t "$HOME" "$package" >/dev/null 2>&1; then
    stow -d "$DOTFILES_ROOT" -t "$HOME" "$package"
    say "Synced $package"
    return
  fi

  say "Package '$package' has live config conflicts."

  while true; do
    read -r -p "Choose [a]dopt into repo, [b]ack up live config, or [s]kip: " action

    case $action in
      a|A)
        stow --adopt -d "$DOTFILES_ROOT" -t "$HOME" "$package"
        say "Adopted and synced $package"
        return
        ;;
      b|B)
        backup_package_targets "$package"
        stow -d "$DOTFILES_ROOT" -t "$HOME" "$package"
        say "Backed up and synced $package"
        return
        ;;
      s|S|'')
        say "Skipped $package"
        return
        ;;
      *)
        say "Please choose a, b, or s."
        ;;
    esac
  done
}

platform=$(detect_platform)
packages=()

if (( $# > 0 )); then
  packages=("$@")
else
  while IFS= read -r package; do
    packages+=("$package")
  done < <(read_manifest "$MANIFEST_ROOT/stow-common.txt")

  case $platform in
    linux-omarchy|linux)
      while IFS= read -r package; do
        packages+=("$package")
      done < <(read_manifest "$MANIFEST_ROOT/stow-linux.txt")
      ;;
    macos)
      while IFS= read -r package; do
        packages+=("$package")
      done < <(read_manifest "$MANIFEST_ROOT/stow-macos.txt")
      ;;
  esac
fi

for package in "${packages[@]}"; do
  [[ -d $DOTFILES_ROOT/$package ]] || {
    warn "Package '$package' is missing from the repo."
    continue
  }

  sync_package "$package"
done

if [[ -d $BACKUP_ROOT ]]; then
  say "Backups were stored in $BACKUP_ROOT"
fi
