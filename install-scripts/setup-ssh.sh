#!/bin/bash

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

# Generate SSH key
read -p "Do you want to generate an SSH key? (y/N) " generate_ssh
if [[ $generate_ssh == "y" ]]; then
	key_type=$(select_option "Select the SSH key type:" "ed25519" "rsa")
	if [[ $key_type == "rsa" ]]; then
		ssh-keygen -t rsa -b 4096 -C "andreasgdp@gmail.com"
		public_key_path="$HOME/.ssh/id_rsa.pub"
	else
		ssh-keygen -t ed25519 -C "andreasgdp@gmail.com"
		public_key_path="$HOME/.ssh/id_ed25519.pub"
	fi

	# Copy public key to clipboard and wait for user to add it to GitHub
	cat "$public_key_path" | xclip -selection clipboard
	echo "Public key copied to clipboard."

	# Press any key to continue after adding key to GitHub
	read -p "Press any key to continue after adding the public key to GitHub..."
fi
