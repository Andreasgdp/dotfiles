#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOTFILES_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

source "$DOTFILES_ROOT/install-scripts/lib/common.sh"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

public_key_path="$HOME/.ssh/id_ed25519.pub"

if [[ -f $HOME/.ssh/id_ed25519 ]]; then
  say "Existing SSH key found at ~/.ssh/id_ed25519"

  if confirm "Generate a fresh ed25519 SSH key anyway?" "N"; then
    ssh-keygen -t ed25519 -C "andreasgdp@gmail.com" -f "$HOME/.ssh/id_ed25519"
  fi
else
  if confirm "Generate a new ed25519 SSH key?" "Y"; then
    ssh-keygen -t ed25519 -C "andreasgdp@gmail.com" -f "$HOME/.ssh/id_ed25519"
  else
    warn "Skipping SSH key generation."
  fi
fi

[[ -f $HOME/.ssh/id_ed25519 ]] && chmod 600 "$HOME/.ssh/id_ed25519"
[[ -f $public_key_path ]] && chmod 644 "$public_key_path"

if [[ -f $public_key_path ]]; then
  if copy_to_clipboard "$public_key_path"; then
    say "Public key copied to clipboard."
  else
    warn "No clipboard helper found. Copy this key manually:"
    sed -n '1p' "$public_key_path"
  fi

  say "GitHub SSH keys: https://github.com/settings/keys"

  if confirm "Open the GitHub SSH keys page now?" "N"; then
    open_url "https://github.com/settings/keys" || warn "Could not open browser automatically."
  fi

  read -r -p "Press Enter after the public key has been added to GitHub..."
fi

touch "$HOME/.ssh/known_hosts"
chmod 644 "$HOME/.ssh/known_hosts"

if ! ssh-keygen -F github.com >/dev/null 2>&1; then
  ssh-keyscan -t ed25519 github.com >> "$HOME/.ssh/known_hosts"
fi

ssh -T git@github.com || true

if [[ -d $DOTFILES_ROOT/.git ]] && git -C "$DOTFILES_ROOT" remote get-url origin >/dev/null 2>&1; then
  origin_url=$(git -C "$DOTFILES_ROOT" remote get-url origin)

  clean_url="${origin_url%.git}"
  if [[ $clean_url =~ ^https://github\.com/([^/]+)/([^/]+)$ ]]; then
    ssh_url="git@github.com:${BASH_REMATCH[1]}/${BASH_REMATCH[2]}.git"

    if confirm "Switch dotfiles origin remote to SSH?" "Y"; then
      git -C "$DOTFILES_ROOT" remote set-url origin "$ssh_url"
      say "Updated origin to $ssh_url"
    fi
  fi
fi
