# Kitty Terminal Configuration

Remember to install the font for the kitty terminal to work properly.

Install the monaspace font from <https://github.com/githubnext/monaspace>

```bash
git clone https://github.com/githubnext/monaspace.git

cd monaspace

./util/install_linux.sh
```

Nerd font icons does not work well with the monaspace font. In arch the icons mostly show, but emojis have a hard time, and in ubuntu it seemed some icons did not work. This NerdFontsSymbolsOnly is especially for icons, so it should cover it.

So, install NerdFontsSymbolsOnly Nerd Font from ryanoasis/nerd-fonts.

```bash
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip

unzip NerdFontsSymbolsOnly.zip -d ~/.local/share/fonts
```

Then, update the font cache.

```bash
fc-cache -fv
```
