#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Ensure all scripts in the specified directory have execution permissions
chmod +x ~/install-os/files/scripts/*.sh || {
  echo "Failed to make scripts executable. Please check the path or permissions."
  exit 1
}

# Function to safely source a script with error checking
source_script() {
  local script_path="$1"
  if [[ -f "$script_path" ]]; then
    echo "Sourcing $script_path..."
    source "$script_path"
  else
    echo "Error: Script $script_path not found!" >&2
    exit 1
  fi
}

# Source each required script
source_script ~/install-os/files/scripts/essentials.sh
sudo ~/install-os/files/scripts/sudoers.sh || {
  echo "Failed to execute sudoers.sh. Please check permissions."
  exit 1
}
source_script ~/install-os/files/scripts/utils.sh
source_script ~/install-os/files/scripts/pyenv.sh
source_script ~/install-os/files/scripts/ssh-config.sh
source_script ~/install-os/files/scripts/zsh-omz.sh
source_script ~/install-os/files/scripts/lightdm.sh

echo "All scripts executed successfully."
