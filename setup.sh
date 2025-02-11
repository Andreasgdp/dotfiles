#!/bin/bash

# check if dotfiles are cloned if not abort and mention to follow readme
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Dotfiles not found in $HOME/dotfiles. Please follow the README to clone the dotfiles repository and run this script again."
  exit 1
fi

# Reusable function for user selection
select_option() {
  PS3="$1 "
  select opt in "${@:2}"; do
    if [[ -n $opt ]]; then
      echo $opt
      return 0
    else
      echo "Invalid option $REPLY"
    fi
  done
}

# reusuable function to check if a command exists
# usage: if ! command_exists "command"; then
command_exists() {
  command -v "$1" &>/dev/null
}

# want to stow dotfiles
read -p "Do you want to stow dotfiles? (y/N) " stow_dotfiles
if [[ $stow_dotfiles == "y" ]]; then
  cd ~/dotfiles
  stow nvim tmux zsh starship kitty rofi localbin htop btop bat fastfetch gitconfig atuin lazygit picom awesome
fi

# extra stuff for rofi
if [ ! -d "$HOME/rofi-emoji" ]; then
  sudo apt install rofi-dev autoconf automake libtool-bin libtool
  git clone https://github.com/Mange/rofi-emoji.git ~/rofi-emoji
  cd ~/rofi-emoji
  git checkout 3-x-stable

  # install rofi-emoji
  autoreconf -i
  mkdir build
  cd build/
  ../configure
  make
  sudo make install
  libtool --finish /usr/lib/x86_64-linux-gnu/rofi//

  cd ~/dotfiles
fi

# Update and upgrade system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y git stow gcc zsh python-is-python3 python3-pip pipx tmux flameshot awesome tree bat rofi pavucontrol htop autoconf luarocks iw ripgrep xdotool peek fd-find direnv tldr duf ack kazam cmatrix gpick luajit

#blueman
sudo apt install -y blueman bluez bluez-obexd

# TODO: finish setup for enabling app image support
# Install FUSE for AppImage support
sudo add-apt-repository universe
sudo apt install libfuse2t64
# Install AppImageLauncher latest _amd64.deb from https://github.com/TheAssassin/AppImageLauncher/releases. E.g. https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
# if ! command_exists "appimagelauncher"; then
# 	cd ~/Downloads
# 	RELEASE_DATA=$(curl -s "https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest")
# 	APPIMAGELAUNCHER_VERSION=$(echo "$RELEASE_DATA" | grep -Po '"tag_name": "\K.*?(?=")')
# 	ASSET_NAME=$(echo "$RELEASE_DATA" | grep -Po '"name": "\K.*?(?=")')
# 	DOWNLOAD_URL="https://github.com/TheAssassin/AppImageLauncher/releases/download/${APPIMAGELAUNCHER_VERSION}/${ASSET_NAME}"
# 	curl -Lo appimagelauncher.deb "$DOWNLOAD_URL"
# fi

# spotify_player
if ! command_exists "spotify_player"; then
  sudo apt install -y libssl-dev libasound2-dev libdbus-1-dev
  brew install spotify_player
fi
if [ ! -f "/usr/local/bin/spotify_player" ] && [ -z "$(command -v spotify_player)" ]; then
  sudo ln -s /home/linuxbrew/.linuxbrew/bin/spotify_player /usr/local/bin/
fi

# Install Lazygit
if ! command_exists "lazygit"; then
  cd ~/
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  # remove lazygit bin and lazygit.tar.gz from current dir
  rm lazygit lazygit.tar.gz
  cd ~/dotfiles/
fi

if ! command_exists "lazydocker"; then
  go install github.com/jesseduffield/lazydocker@latest
fi

# check if homebrew is installed and install if not
if ! command_exists "brew"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  sudo apt install build-essential
  brew install gcc
fi

if ! command_exists "fzf"; then
  brew install fzf
fi

if ! command_exists "fd"; then
  brew install fd
fi

if ! command_exists "fuck"; then
  brew install thefuck
fi

if ! command_exists "delta"; then
  brew install git-delta
fi

if ! command_exists "btop"; then
  brew install btop
fi

if ! command_exists "google-java-format"; then
  brew install google-java-format
fi

if ! command_exists "atuin"; then
  # atuin command history
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  atuin import auto
fi

# installing brightnessctl as a suid binary
if ! command_exists "brightnessctl"; then
  sudo apt install -y brightnessctl
  sudo chmod u+s /usr/bin/brightnessctl
fi

if ! command_exists "steam"; then
  read -p "Do you want to install steam? (y/N) " install_steam
  if [[ $install_steam == "y" ]]; then
    sudo snap install steam
  fi
fi

read -p "Do you want personal desktop setup? (y/N) " is_personal_desktop
if [[ $is_personal_desktop == "y" ]]; then
  cd ~/dotfiles
  stow screenlayout
  if [ ! -d "$HOME/switch-audio-sinks" ]; then
    git clone git@github.com:Andreasgdp/switch-audio-sinks.git ~/git/switch-audio-sinks
  fi
  # streamdeck (source: https://github.com/streamdeck-linux-gui/streamdeck-linux-gui)
  if ! command_exists "streamdeck"; then
    sudo apt -y install libhidapi-libusb0 pipx
    sudo wget https://raw.githubusercontent.com/streamdeck-linux-gui/streamdeck-linux-gui/main/udev/60-streamdeck.rules -O /etc/udev/rules.d/60-streamdeck.rules
    sudo udevadm trigger
  fi
fi

# Install Starship prompt
if ! command_exists "starship"; then
  curl -sS https://starship.rs/install.sh | sh
fi

# Install eza
# First make sure to have gpg
if ! command_exists "eza"; then
  sudo apt install -y gpg

  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
fi

# Install zoxide
if ! command_exists "zoxide"; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Install fastfetch
if ! command_exists "fastfetch"; then
  sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
  sudo apt update
  sudo apt install -y fastfetch
fi

# Install Neovim
if ! command_exists "nvim"; then
  # TODO: consider if the installation method should be different
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  rm nvim-linux64.tar.gz
fi

# Language servers
npm list -g @astrojs/language-server || npm i -g @astrojs/language-server

# betterlockscreen
if ! command_exists "betterlockscreen"; then
  sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

  cd
  git clone https://github.com/Raymo111/i3lock-color.git
  cd i3lock-color
  ./install-i3lock-color.sh

  cd ~/dotfiles

  sudo apt install imagemagick -y

  wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | bash -s user
fi

if ! command_exists "conventional-pre-commit"; then
  pipx install conventional-pre-commit
  pipx ensurepath
fi

# Install and set up Tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if ! command_exists "n"; then
  curl -L https://bit.ly/n-install | bash
fi

# Fix audio issues on Dell laptops
# TODO: Fix any audio issues on Dell laptops

# Enable advanced touchpad gestures
# TODO: Include commands or scripts to enable these gestures
# Follow instructions on: https://ubuntuhandbook.org/index.php/2024/06/enable-enhance-touchpad-gestures-ubuntu/

# Install Google Chrome
# Source: https://askubuntu.com/a/1479315/1177561
if ! command_exists "google-chrome-stable"; then
  wget -P ~/Downloads https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
  sudo apt --fix-broken install
fi

if ! command_exists "brave-browser"; then
  curl -fsS https://dl.brave.com/install.sh | sh
fi

# intsall flatpak
if ! command_exists "flatpak"; then
  sudo apt install -y flatpak
fi

# stow yazi
if [ ! -d "~/.config/yazi" ]; then
  stow yazi
fi
# Install Yazi (terminal file manager)
if ! command_exists "yazi"; then
  brew install yazi
fi

if ! command_exists "picom"; then
  "$HOME"/dotfiles/install-scripts/setups/picom.sh
fi

if ! command_exists "simplescreenrecorder"; then
  "$HOME"/dotfiles/install-scripts/setups/SimpleScreenRecorder.sh
fi

# Install Arc GTK theme
if [ ! -d "$HOME/arc-icon-theme" ]; then
  git clone --depth 1 https://github.com/horst3180/arc-icon-theme ~/arc-icon-theme/ && cd ~/arc-icon-theme/
  ./autogen.sh --prefix=/usr
  sudo make install
  cd ~/dotfiles
fi

if [ ! -d "$HOME/fzf-git.sh" ]; then
  git clone https://github.com/junegunn/fzf-git.sh.git ~/fzf-git.sh
fi

# Install Oh My Zsh
# if .oh-my-zsh directory does not exist run the install script
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  export RUNZSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/Aloxaf/fzf-tab.git ~/.oh-my-zsh/custom/plugins/fzf-tab
  git clone https://github.com/chrissicool/zsh-256color ~/.oh-my-zsh/custom/plugins/zsh-256color
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# setup monaspace, jetbrains nerd fonts and symbols
if [ ! -d "$HOME/monaspace" ]; then
  git clone https://github.com/githubnext/monaspace.git ~/monaspace
  cd ~/monaspace
  ./util/install_linux.sh
  cd ~/dotfiles
fi
# Install JetBrains Nerd Font Mono - it has it's own condition check to avoid reinstallation
./install-scripts/fonts/jetbrains-nerd-mono.sh
if [ ! -f "$HOME/.local/share/fonts/SymbolsNerdFont-Regular.ttf" ]; then
  cd ~/Downloads
  curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
  unzip NerdFontsSymbolsOnly.zip -d ~/.local/share/fonts
  fc-cache -fv
  cd ~/dotfiles
fi

# Install Kitty terminal emulator
if ! command_exists "kitty"; then
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
  # your system-wide PATH)
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
  # Place the kitty.desktop file somewhere it can be found by the OS
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
  # Update the paths to the kitty and its icon in the kitty desktop file(s)
  sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
  # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
  echo 'kitty.desktop' >~/.config/xdg-terminals.list
fi
