#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
DOTFILES_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

sudo install -m 0755 \
  "$DOTFILES_ROOT/localbin/.local/bin/kvm-suspend-on-poweroff" \
  "/usr/local/bin/kvm-suspend-on-poweroff"

sudo install -m 0644 \
  "$DOTFILES_ROOT/install-scripts/udev/99-kvm-suspend.rules" \
  "/etc/udev/rules.d/99-kvm-suspend.rules"

sudo udevadm control --reload

printf 'Installed /usr/local/bin/kvm-suspend-on-poweroff\n'
printf 'Installed /etc/udev/rules.d/99-kvm-suspend.rules\n'
