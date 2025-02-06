#!/bin/bash
#
# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to log messages with color
log_message() {
  local color="$1"
  local message="$2"
  echo -e "${color}${message}${NC}"
}
log_message "${BLUE}" "Installing picom..."

# define url variable
gitCloneUrl="https://github.com/yshui/picom.git"

log_message "${YELLOW}" "Cloning picom from $gitCloneUrl..."
if [ ! -d "$HOME/picom" ]; then
  git clone "$gitCloneUrl" "$HOME/picom"
else
  # if git config --get remote.origin.url is not https://github.com/tryone144/compton.git
  if [ "$(git config --get remote.origin.url)" != "$gitCloneUrl" ]; then
    log_message "${YELLOW}" "$HOME/picom already exists. Cloning to $HOME/picom_old..."
    # promt the user to ask them to cancel if picom_old already exists
    if [ -d "$HOME/picom_old" ]; then
      # ask the user to cancel
      log_message "${RED}" "$HOME/picom_old already exists, do you want to continue? (y/n)"
      read -r response
      if [ "$response" != "y" ]; then
        log_message "${RED}" "Exiting..."
        exit 1
      fi
    fi
    # mv $HOME/picom $HOME/picom_old
    rm -rf "$HOME"/picom_old
    mv -f "$HOME"/picom "$HOME"/picom_old
    # clone
    git clone "$gitCloneUrl" "$HOME/picom"
  else
    log_message "${GREEN}" "$HOME/picom already exists. Skipping cloning."
  fi
fi

log_message "${YELLOW}" "Updating package lists..."
sudo apt-get update
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to update package lists."
  exit 1
fi
log_message "${GREEN}" "Package lists updated."

log_message "${YELLOW}" "Installing dependencies..."
sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to install dependencies."
  exit 1
fi
log_message "${GREEN}" "Dependencies installed."
log_message "${YELLOW}" "Installing dependencies using brew (becuse for some reason the ones installed using apt are not working/accepted)..."
brew install pixman xcb-util-image xcb-util-renderutil libepoxy
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to install dependencies with brew."
  exit 1
fi
log_message "${GREEN}" "Dependencies installed."

log_message "${YELLOW}" "Building picom..."
# make
(
  cd "$HOME"/picom || {
    log_message "${RED}" "Error: Failed to change directory to $HOME/picom."
    exit 1
  }

  meson setup --buildtype=release build
  ninja -C build
)

log_message "${GREEN}" "Building done."

log_message "${YELLOW}" "Installing picom binary..."
(
  cd "$HOME"/picom || {
    log_message "${RED}" "Error: Failed to change directory to $HOME/picom."
    exit 1
  }

  sudo ninja -C build install
)
