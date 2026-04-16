#!/bin/bash

set -euo pipefail

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

case "$(uname -s)" in
  Linux)
    if ! command_exists omarchy-pkg-add; then
      printf 'This bootstrap currently expects Omarchy on Linux.\n' >&2
      exit 1
    fi

    omarchy-pkg-add git stow curl
    ;;
  Darwin)
    if ! command_exists git; then
      printf 'Install Xcode Command Line Tools first, then rerun this bootstrap.\n' >&2
      exit 1
    fi
    ;;
  *)
    printf 'Unsupported platform.\n' >&2
    exit 1
    ;;
esac

if [[ ! -d $HOME/dotfiles/.git ]]; then
  git clone https://github.com/Andreasgdp/dotfiles.git "$HOME/dotfiles"
fi

exec "$HOME/dotfiles/install-scripts/bootstrap.sh"
