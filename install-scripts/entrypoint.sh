sudo apt update
sudo apt upgrade -y
sudo apt install git stow curl

# run the single script from github
curl -s https://raw.githubusercontent.com/Andreasgdp/dotfiles/master/install-scripts/setup-ssh.sh | bash

# clone the dotfiles repo
git clone git@github.com:Andreasgdp/dotfiles.git ~/dotfiles

if [ ! -d "$HOME/dotfiles" ]; then
	echo "Dotfiles not found in $HOME/dotfiles. Please clone the dotfiles repository and run this script again."
	exit 1
fi

# run setup.sh
~/dotfiles/install-scripts/setup.sh
