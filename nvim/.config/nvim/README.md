# NeoVim setup

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
