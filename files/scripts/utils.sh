#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Ensure required commands are available
for cmd in sudo apt wget unzip install ln mkdir; do
  if ! command -v $cmd &>/dev/null; then
    echo "Error: Required command '$cmd' not found. Please install it and try again."
    exit 1
  fi
done

# Create the local bin directory
mkdir -p ~/.local/bin

# Install bat and create a symbolic link to batcat
if ! command -v bat &>/dev/null; then
  echo "Installing bat..."
  sudo apt install -y bat
  sudo ln -sf /usr/bin/batcat /usr/bin/bat
  echo "bat installed and linked successfully."
else
  echo "bat is already installed."
fi

# Install pfetch
echo "Installing pfetch..."
PFETCH_TEMP_DIR=$(mktemp -d)
wget -q https://github.com/dylanaraps/pfetch/archive/master.zip -O "$PFETCH_TEMP_DIR/master.zip"
unzip -q "$PFETCH_TEMP_DIR/master.zip" -d "$PFETCH_TEMP_DIR"
sudo install "$PFETCH_TEMP_DIR"/pfetch-master/pfetch /usr/local/bin/
rm -rf "$PFETCH_TEMP_DIR"
echo "pfetch installed successfully."

# Install and configure neovim
echo "Installing neovim..."
if ! command -v nvim &>/dev/null; then
  NVIM_TEMP_DIR=$(mktemp -d)
  wget -q https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O "$NVIM_TEMP_DIR/nvim.appimage"
  chmod +x "$NVIM_TEMP_DIR/nvim.appimage"
  sudo mv "$NVIM_TEMP_DIR/nvim.appimage" /usr/local/bin/nvim
  ln -sf /usr/local/bin/nvim ~/.local/bin/vim
  rm -rf "$NVIM_TEMP_DIR"
  echo "Neovim installed and linked successfully."
  else
  echo "Neovim is already installed."
fi

# Configure neovim
echo "Configuring neovim..."
mkdir -p ~/.config/nvim
if [[ ! -f ~/.config/nvim/init.vim ]]; then
  cp ~/install-os/files/init.vim ~/.config/nvim/init.nvim
  echo "neovim configuration copied."
else
  echo "neovim configuration already exists."
fi

echo "All utilities installed and configured successfully."
