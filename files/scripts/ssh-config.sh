#!/bin/bash

# Exit on any error or unset variable, and treat errors in pipelines properly
set -euo pipefail

# Array of SSH key names for different purposes
keys=("devices" "personal_repos" "spc_vpn")

# Generate SSH keys for each purpose
echo "Generating SSH keys..."
for key in "${keys[@]}"; do
    KEY_PATH="$HOME/.ssh/id_rsa_$key"
    
    # Check if the key already exists
    if [[ -f "$KEY_PATH" ]]; then
        echo "Key for '$key' already exists at $KEY_PATH. Skipping."
    else
        ssh-keygen -N "" -f "$KEY_PATH" -C "$(whoami)@$(hostname)_for_$key"
        echo "Key for '$key' created at $KEY_PATH."
    fi
done

# Check if the SSH config file exists before copying
SSH_CONFIG_SOURCE="$HOME/install-os/files/ssh-config"
SSH_CONFIG_TARGET="$HOME/.ssh/config"

if [[ -f "$SSH_CONFIG_SOURCE" ]]; then
    echo "Copying SSH configuration file to $SSH_CONFIG_TARGET..."
    cp "$SSH_CONFIG_SOURCE" "$SSH_CONFIG_TARGET"
    chmod 600 "$SSH_CONFIG_TARGET"  # Secure permissions for the config file
    echo "SSH configuration updated."
else
    echo "Error: SSH configuration file not found at $SSH_CONFIG_SOURCE."
    exit 1
fi

echo "SSH setup completed successfully."
