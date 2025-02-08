#!/bin/bash

# Check if JetBrains Mono Nerd Font is already installed
if fc-list | grep -qi "JetBrainsMono Nerd Font Mono"; then
  echo "JetBrains Mono Nerd Font is already installed. Aborting."
  exit 0
fi

# Function to get the latest JetBrains Mono Nerd Font release URL
get_latest_font_url() {
  # Use curl to fetch the latest release info from GitHub API
  local url=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | \
    jq -r '.assets[] | select(.name | endswith(".zip") and startswith("JetBrainsMono")) | .browser_download_url')

  if [[ -z "$url" ]]; then
    echo "Error: No .zip file found for JetBrains Mono Nerd Font."
    exit 1
  fi

  echo "$url"
}

# Function to download and install the font
install_font() {
  local font_url="$1"
  local font_file=$(basename "$font_url")
  local font_dir="$HOME/.fonts"  # Or /usr/share/fonts, but requires sudo

  # Create the font directory if it doesn't exist
  mkdir -p "$font_dir"

  # Download the font
  wget -q "$font_url" -O "$font_dir/$font_file"

  # Extract the font (assuming it's a zip or ttf.zip)
  if [[ "$font_file" == *.zip ]]; then
    unzip -q "$font_dir/$font_file" -d "$font_dir"
    rm "$font_dir/$font_file" # Remove the zip file after extraction
  elif [[ "$font_file" == *.ttf.zip ]]; then
        unzip -q "$font_dir/$font_file" -d "$font_dir"
    rm "$font_dir/$font_file" # Remove the zip file after extraction
  fi

  # Update font cache
  fc-cache -fv

  echo "JetBrains Mono Nerd Font installed."
}

# Main script logic
latest_url=$(get_latest_font_url)

if [[ -n "$latest_url" ]]; then
  install_font "$latest_url"
else
  echo "Failed to get the latest font URL."
  exit 1
fi

echo "Font installation and configuration complete."
