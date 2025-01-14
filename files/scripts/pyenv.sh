#!/bin/bash

sudo apt update -y; sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install pyenv and virtualenvwrapper
curl https://pyenv.run | bash

# Export pyenv PATH
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Get the latest available Python version from pyenv
LATEST_VERSION=$(pyenv install --list | grep -E '^[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')

# Check if a valid version was retrieved
if [ -z "$LATEST_VERSION" ]; then
  echo "Could not determine the latest Python version using pyenv."
  exit 1
fi

echo "Latest Python version found: $LATEST_VERSION"

# Check if the version is already installed
if pyenv versions | grep -q "$LATEST_VERSION"; then
  echo "Version $LATEST_VERSION is already installed."
else
  echo "Installing Python $LATEST_VERSION..."
  pyenv install "$LATEST_VERSION"
  
  # Exit if the installation fails
  if [ $? -ne 0 ]; then
    echo "An error occurred while installing Python $LATEST_VERSION."
    exit 1
  fi
fi

# Set the latest version as the global default
echo "Setting Python $LATEST_VERSION as the global version..."
pyenv global "$LATEST_VERSION"

# Confirm the current global version
echo "The global Python version is now:"
pyenv global

# Install pyenv-virtualenvwrapper
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper
pyenv virtualenvwrapper