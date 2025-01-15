#!/bin/bash

# Exit immediately if a command exits with a non-zero status, undefined variable, or pipe failure
set -euo pipefail

# Ensure required commands are available
for cmd in sudo apt curl git; do
  if ! command -v $cmd &>/dev/null; then
    echo "Error: Required command '$cmd' not found. Please install it and try again."
    exit 1
  fi
done

# Update and install necessary dependencies
echo "Updating system and installing dependencies..."
sudo apt update -y && sudo apt install -y \
  build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev \
  libxmlsec1-dev libffi-dev liblzma-dev

# Install pyenv if not already installed
if [[ ! -d "$HOME/.pyenv" ]]; then
  echo "Installing pyenv..."
  curl https://pyenv.run | bash
else
  echo "pyenv is already installed."
fi

# Export pyenv PATH and initialize
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

if ! command -v pyenv &>/dev/null; then
  echo "Error: pyenv installation failed. Please check the installation steps."
  exit 1
fi

eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"

# Retrieve the latest Python version
echo "Retrieving the latest Python version..."
LATEST_VERSION=$(pyenv install --list | grep -E '^[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')

if [[ -z "$LATEST_VERSION" ]]; then
  echo "Error: Could not determine the latest Python version using pyenv."
  exit 1
fi

echo "Latest Python version found: $LATEST_VERSION"

# Check if the version is already installed
if pyenv versions | grep -q "$LATEST_VERSION"; then
  echo "Python $LATEST_VERSION is already installed."
else
  echo "Installing Python $LATEST_VERSION..."
  pyenv install "$LATEST_VERSION" || {
    echo "Error: Failed to install Python $LATEST_VERSION."
    exit 1
  }
fi

# Set the latest version as the global default
echo "Setting Python $LATEST_VERSION as the global version..."
pyenv global "$LATEST_VERSION"

# Confirm the global version
GLOBAL_VERSION=$(pyenv global)
echo "The global Python version is now: $GLOBAL_VERSION"

# Install pyenv-virtualenvwrapper if not already installed
VIRTUALENVWRAPPER_PLUGIN="$PYENV_ROOT/plugins/pyenv-virtualenvwrapper"
if [[ ! -d "$VIRTUALENVWRAPPER_PLUGIN" ]]; then
  echo "Installing pyenv-virtualenvwrapper..."
  git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git "$VIRTUALENVWRAPPER_PLUGIN"
else
  echo "pyenv-virtualenvwrapper is already installed."
fi

echo "Setup completed successfully."
