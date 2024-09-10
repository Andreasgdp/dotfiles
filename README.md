# dotfiles

> **_Important_** This repo is made for personal use and is not intended to be used by others. However, feel free to use it as a reference or inspiration for your own dotfiles.

This repository contains my dotfiles and use GNU Stow to manage them.

## OS-Post-Install process

This is the process I follow after a fresh install of a Ubuntu based system.

Run the following command and follow the instructions to get the system up and running.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Andreasgdp/dotfiles/master/install-scripts/entrypoint.sh)
```

## Basic setup of only configuration files

This is part of the above script but can be run separately.

- Clone the repo **into your user home directory**
- Stow

```bash
sudo apt install stow
```

- Stow the desired configuration (from the root of the dotfiles repo) e.g. for neovim

```bash
stow nvim
```

For this case it will create a symlink from `~/.config/nvim` to `dotfiles/nvim`

## Notes

Things that need to be done manually (for now)

### zsh completions

Install atuin and setup completions for zsh

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

WIP
