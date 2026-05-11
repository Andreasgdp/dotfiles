# dotfiles

> **_Important_** This repo is made for personal use and is not intended to be used by others. However, feel free to use it as a reference or inspiration for your own dotfiles.

This repository contains my dotfiles and uses GNU Stow to manage them.

## First Thing After Installing Omarchy ISO

This is the first thing to do on a fresh Omarchy install to get back to a working setup quickly.

1. Clone this repo into `~/dotfiles`.
2. Run `./setup.sh`.
3. Follow the prompts to install repo packages, AUR packages, Flatpak apps, and stowed dotfile packages.

```bash
git clone https://github.com/Andreasgdp/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

That bootstrap flow is the source of truth for getting the machine back into a usable state.

## What Setup Manages

- repo packages from `install-scripts/manifests/linux-omarchy-packages.txt`
- AUR packages from `install-scripts/manifests/linux-omarchy-aur-packages.txt`
- Flatpak apps from `install-scripts/manifests/linux-flatpak-apps.txt`
- dotfile packages via GNU Stow

## Dotfiles Only

If packages are already installed and only the config needs to be synced:

```bash
cd ~/dotfiles
./install-scripts/sync-dotfiles.sh
```

Or stow a single package manually, for example:

```bash
stow nvim
```

That creates a symlink from `~/.config/nvim` to `~/dotfiles/nvim`.

## Notes

### System Configuration

#### Laptop

##### Close lid

```bash
[Login]
...
HandlePowerKey=hibernate
#HandleSuspendKey=suspend
#HandleHibernateKey=hibernate
HandleLidSwitch=suspend
...
HoldoffTimeoutSec=30s
IdleAction=hybrid-sleep
IdleActionSec=30min
...
```
## NeoVim setup

This is my neovim setup. I use it for web development, so it's optimized for that.

It is based on [LazyVim](https://www.lazyvim.org/).

## Complete reset of local neovim setup

Run the following if something goes wrong and you want to reset your local neovim setup to the state from the one in this repository.

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim/
```

If you ever get the error of lsp syntax highlight working wonky in typescript run the following nvim commands

```
:TSInstall typescript
:TSInstall tsx
```
