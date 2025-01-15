#!/bin/bash

# Exit on any error or unset variable, and treat errors in pipelines properly
set -euo pipefail

echo "Changing login manager to LightDM..."

# Check if LightDM is already installed
if dpkg -l | grep -qw lightdm; then
    echo "LightDM is already installed."
else
    echo "Installing LightDM..."
    sudo apt update
    sudo apt install -y lightdm
fi

# Reconfigure LightDM as the default display manager
echo "Reconfiguring LightDM as the default display manager..."
if sudo dpkg-reconfigure -f noninteractive lightdm; then
    echo "LightDM has been successfully set as the default display manager."
else
    echo "An error occurred during LightDM configuration. Please check your system settings."
    exit 1
fi

# Confirm the active display manager
echo "Current active display manager:"
systemctl status display-manager | grep "Loaded" || echo "Unable to determine the active display manager."

echo "Setup complete. Please reboot your system to apply the changes."
