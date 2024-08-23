sudo apt update
sudo apt upgrade -y
sudo apt install -y git stow curl xclip

# run the single script from github
bash <(curl -fsSL https://raw.githubusercontent.com/Andreasgdp/dotfiles/master/install-scripts/setup-ssh.sh)

# clone the dotfiles repo
if [ ! -d "$HOME/dotfiles" ]; then
	git clone git@github.com:Andreasgdp/dotfiles.git ~/dotfiles
fi

if [ ! -d "$HOME/dotfiles" ]; then
	echo "Dotfiles not found in $HOME/dotfiles. Please clone the dotfiles repository and run this script again."
	exit 1
fi

# run setup.sh
~/dotfiles/setup.sh
