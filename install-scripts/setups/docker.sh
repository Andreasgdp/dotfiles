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
nameOfThisScriptFile=$(basename "$0")
log_message "${BLUE}" "Installing $nameOfThisScriptFile"

log_message "${YELLOW}" "Set up Docker's apt repository"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to add Docker's apt repository."
  exit 1
fi

log_message "${BLUE}" "Install the Docker packages"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to install Docker packages."
  exit 1
fi

log_message "${YELLOW}" "Verifying the installation by running the hello-world image"
sudo docker run hello-world
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to run the hello-world image."
  exit 1
fi

# follow this link to manage Docker as a non-root user
# https://docs.docker.com/engine/install/linux-postinstall/
