#!/bin/bash

set -euo pipefail

DOTFILES_ROOT="$HOME/dotfiles"

if [[ ! -d $DOTFILES_ROOT ]]; then
  printf 'Dotfiles not found in %s. Clone the repo and run this script again.\n' "$DOTFILES_ROOT" >&2
  exit 1
fi

exec "$DOTFILES_ROOT/install-scripts/bootstrap.sh"
