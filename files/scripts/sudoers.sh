#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Ensure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Error: This script must be run as root."
  exit 1
fi

# Get the name of the user executing the script
USER=${SUDO_USER:-$(whoami)}

# Validate the user name
if [[ -z "$USER" ]]; then
  echo "Error: Unable to determine the username. Ensure the script is run via sudo."
  exit 1
fi

# Define the path for the sudoers file
SUDOERS_FILE="/etc/sudoers.d/$USER"

# Content to write into the file
SUDOERS_CONTENT="$USER ALL=(ALL:ALL) NOPASSWD: /usr/bin/apt,/usr/bin/apt-get,/usr/bin/bat,/usr/bin/ls,/usr/bin/mkdir"

# Write the sudoers content safely using visudo
{
  echo "Writing sudoers file for user: $USER..."
  echo "$SUDOERS_CONTENT" | EDITOR="tee" visudo -f "$SUDOERS_FILE"
} || {
  echo "Error: Failed to write to $SUDOERS_FILE. Please check permissions or syntax."
  exit 1
}

# Ensure correct permissions on the file
chmod 440 "$SUDOERS_FILE"
echo "Sudoers file created at $SUDOERS_FILE with correct permissions."

# Confirm success
echo "Sudoers configuration for $USER has been successfully applied."
