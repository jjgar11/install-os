#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Ensure required commands are available
for cmd in sudo apt; do
  if ! command -v $cmd &>/dev/null; then
    echo "Error: Required command '$cmd' not found. Please install it and try again."
    exit 1
  fi
done

echo "Starting system update and upgrade..."
# Update and upgrade system packages
sudo apt update && sudo apt full-upgrade -y
echo "System updated successfully."

echo "Installing essential packages..."
# Install essential packages
sudo apt install -y \
  build-essential nano gedit curl git wget gpg net-tools unzip neofetch python3
echo "Basic essential packages installed."

echo "Installing development libraries..."
# Install development libraries
sudo apt install -y \
  make libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm \
  libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
  python3-openssl
echo "Development libraries installed successfully."

echo "All essential packages and libraries installed successfully."
