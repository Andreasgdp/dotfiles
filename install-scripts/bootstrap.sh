#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOTFILES_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

source "$DOTFILES_ROOT/install-scripts/lib/common.sh"

linux_install_manifest() {
  local title=$1
  local manifest=$2
  local installer=$3
  local pkg

  say ""
  say "$title"

  while IFS= read -r pkg; do
    if omarchy-pkg-present "$pkg" >/dev/null 2>&1; then
      say "  - $pkg (installed)"
      continue
    fi

    if confirm "Install $pkg?" "Y"; then
      "$installer" "$pkg"
    else
      say "  - skipped $pkg"
    fi
  done < <(read_manifest "$manifest")
}

flatpak_install_manifest() {
  local title=$1
  local manifest=$2
  local app

  command_exists flatpak || {
    say ""
    say "$title"
    say "  - flatpak is not installed; skipping Flatpak apps"
    return
  }

  say ""
  say "$title"

  while IFS= read -r app; do
    if flatpak info "$app" >/dev/null 2>&1; then
      say "  - $app (installed)"
      continue
    fi

    if confirm "Install $app?" "Y"; then
      flatpak install -y flathub "$app"
    else
      say "  - skipped $app"
    fi
  done < <(read_manifest "$manifest")
}

macos_install_manifest() {
  local title=$1
  local manifest=$2
  local brew_args=$3
  local pkg

  say ""
  say "$title"

  while IFS= read -r pkg; do
    if brew list $brew_args "$pkg" >/dev/null 2>&1; then
      say "  - $pkg (installed)"
      continue
    fi

    if confirm "Install $pkg?" "Y"; then
      brew install $brew_args "$pkg"
    else
      say "  - skipped $pkg"
    fi
  done < <(read_manifest "$manifest")
}

platform=$(detect_platform)

case $platform in
  linux-omarchy)
    omarchy-pkg-add git stow curl
    ;;
  macos)
    command_exists git || die "Install Xcode Command Line Tools before running this bootstrap."
    ensure_brew
    brew install stow git curl
    ;;
  *)
    die "Unsupported platform '$platform'. This bootstrap currently supports Omarchy and macOS."
    ;;
esac

say "Bootstrap platform: $platform"

if confirm "Review SSH setup now?" "N"; then
  "$DOTFILES_ROOT/install-scripts/setup-ssh.sh"
fi

case $platform in
  linux-omarchy)
    if confirm "Review Linux packages to install?" "Y"; then
      linux_install_manifest "Repo packages" "$MANIFEST_ROOT/linux-omarchy-packages.txt" omarchy-pkg-add
      linux_install_manifest "AUR packages" "$MANIFEST_ROOT/linux-omarchy-aur-packages.txt" omarchy-pkg-aur-add
      flatpak_install_manifest "Flatpak apps" "$MANIFEST_ROOT/linux-flatpak-apps.txt"
    fi
    ;;
  macos)
    if confirm "Review Homebrew packages to install?" "Y"; then
      macos_install_manifest "Formulae" "$MANIFEST_ROOT/macos-formulae.txt" "--formula"
      macos_install_manifest "Casks" "$MANIFEST_ROOT/macos-casks.txt" "--cask"
    fi
    ;;
esac

if confirm "Sync dotfile packages with GNU Stow?" "Y"; then
  "$DOTFILES_ROOT/install-scripts/sync-dotfiles.sh"
fi

say ""
say "Bootstrap complete."
