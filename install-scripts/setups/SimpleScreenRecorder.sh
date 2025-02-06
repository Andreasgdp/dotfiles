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
log_message "${BLUE}" "Installing SimpleScreenRecorder"

log_message "${YELLOW}" "Updating package lists..."
sudo apt update
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to update package lists."
  exit 1
fi

log_message "${YELLOW}" "Installing SimpleScreenRecorder..."
sudo apt-get install simplescreenrecorder
if [[ $? -ne 0 ]]; then
  log_message "${RED}" "Error: Failed to install SimpleScreenRecorder."
  exit 1
fi

log_message "${GREEN}" "SimpleScreenRecorder installed."
