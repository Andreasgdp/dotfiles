# Bootstrap

## Main entry points

- `./setup.sh`
- `./install-scripts/bootstrap.sh`
- `./install-scripts/sync-dotfiles.sh`

`setup.sh` runs the platform-aware bootstrap for the cloned repo.

## What bootstrap does

- Detects `linux-omarchy` or `macos`
- Ensures the package manager prerequisites are available
- Offers interactive SSH setup
- Reviews packages one by one before installing them
- Offers interactive `stow` syncing for the dotfile packages

## Sync strategy

`sync-dotfiles.sh` uses GNU Stow and asks per package:

- sync now
- adopt the live machine config into the repo with `stow --adopt`
- back up the live config and replace it with the repo version
- skip it

Backups are stored in `~/.dotfiles-backups/<timestamp>/`.

## SSH bootstrap recommendation

For a fresh machine, the safest flow is:

1. Clone the repo over HTTPS first.
2. Run `./setup.sh`.
3. Generate a fresh SSH key on the new machine.
4. Add the public key to GitHub.
5. Switch remotes to SSH after auth works.

Do not bake private SSH keys into the repo or an install image.

## Omarchy ISO options

Yes, you can extend the Omarchy install experience, but the safest path is not to embed your full personal state into the ISO.

Recommended approach:

1. Keep the ISO mostly stock.
2. Add a small first-run bootstrap step that clones the repo and runs `./setup.sh`.
3. Use HTTPS for the first clone, then configure SSH on the installed machine.

If you want a custom ISO later, keep it limited to:

- package additions
- a first-boot script or systemd user service
- your public repo URL

Do not include:

- private keys
- machine-specific secrets
- host-specific state

The `jj/.config/jj/repos/` data is intentionally excluded from sync for this reason.
