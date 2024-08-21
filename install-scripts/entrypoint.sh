sudo apt update
sudo apt upgrade -y
sudo apt install -y git stow curl xclip

# run the single script from github
# script need interactivity so it is not possible to run it with curl | bash
curl -s -O https://raw.githubusercontent.com/Andreasgdp/dotfiles/master/install-scripts/setup-ssh.sh
chmod +x setup-ssh.sh
./setup-ssh.sh
# remove the script after running it
rm setup-ssh.sh

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
