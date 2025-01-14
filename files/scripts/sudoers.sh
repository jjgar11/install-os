#!/bin/bash

# Get the name of the user executing the script
USER=$(whoami)

# Validate that the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# Define the path for the sudoers file
SUDOERS_FILE="/etc/sudoers.d/$USER"

# Content to write into the file
SUDOERS_CONTENT="$USER ALL=(ALL:ALL) NOPASSWD: /usr/bin/apt,/usr/bin/apt-get,/usr/bin/bat,/usr/bin/ls,/usr/bin/mkdir"

# Create or overwrite the file with the content
echo "$SUDOERS_CONTENT" > "$SUDOERS_FILE"

# Ensure correct permissions on the file
chmod 440 "$SUDOERS_FILE"
