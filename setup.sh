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
read -p "Do you want to stow dotfiles? (y/n) " stow_dotfiles
if [[ $stow_dotfiles == "y" ]]; then
	stow nvim tmux zsh starship kitty rofi localbin htop btop bat fastfetch gitconfig
fi

# Update and upgrade system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y git stow gcc zsh python-is-python3 python3-pip pipx tmux fzf flameshot awesome

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
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
fi

# Install Oh My Zsh
# if .oh-my-zsh directory does not exist run the install script
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

# Install pynvim via pipx
# TODO: see if this is necessary
# pipx install pynvim

# Install and set up Tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

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

# Install Yazi (terminal file manager)
if ! command_exists "yazi"; then
	curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest |
		grep "browser_download_url.*yazi-x86_64-unknown-linux-gnu.snap" |
		cut -d : -f 2,3 |
		tr -d \" |
		wget -P ~/Downloads -i - -O yazi.snap

	# Install Yazi from the downloaded file
	sudo snap install --dangerous ~/Downloads/yazi.snap
fi

# TODO:make AwesomeWM config part of the dotfiles repo

# clone git@github.com:Andreasgdp/awesome.git into ~/.config/awesome and run git submodule update --init --recursive in the repo
if [ ! -d "$HOME/.config/awesome" ]; then
	git clone git@github.com:Andreasgdp/awesome.git ~/.config/awesome
	cd ~/.config/awesome
	git submodule update --init --recursive
	cd -
fi

echo "Setup script completed."

# TODO: Add more installation steps or configurations as needed
