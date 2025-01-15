#!/bin/bash

set -euo pipefail

LOG_FILE=~/install-os/install.log
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting installation process at $(date)..."

# Function to run each script and handle errors
run_script() {
    local script=$1
    echo "Running $script..."
    if bash "$script"; then
        echo "✅ Successfully ran $script."
    else
        echo "❌ Error occurred while running $script. Continuing with the next step..."
    fi
}

# Make all scripts executable
chmod +x ~/install-os/files/scripts/*.sh

# Run scripts in order
scripts=(
    "~/install-os/files/scripts/essentials.sh"
    "~/install-os/files/scripts/sudoers.sh"
    "~/install-os/files/scripts/utils.sh"
    "~/install-os/files/scripts/pyenv.sh"
    "~/install-os/files/scripts/ssh-config.sh"
    "~/install-os/files/scripts/zsh-omz.sh"
    "~/install-os/files/scripts/lightdm.sh"
)

for script in "${scripts[@]}"; do
    run_script "$script"
done

echo "Installation process completed at $(date). Check the log at $LOG_FILE for details."
