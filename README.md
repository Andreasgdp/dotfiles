# dotfiles

This repository contains my dotfiles and use GNU Stow to manage them.

## Installation

- Clone the repo
- Stow

```bash
sudo apt install stow
```

or

```bash
yay -S stow
```

- Stow the desired configuration (from the root of the dotfiles repo) e.g. for neovim

```bash
stow nvim
```

For this case it will create a symlink from `~/.config/nvim` to `dotfiles/nvim`
