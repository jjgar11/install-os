#!/bin/bash

chmod +x ~/install-os/files/scripts/*.sh

source ~/install-os/files/scripts/essentials.sh
sudo ~/install-os/files/scripts/sudoers.sh
source ~/install-os/files/scripts/utils.sh
source ~/install-os/files/scripts/pyenv.sh
source ~/install-os/files/scripts/ssh-config.sh
source ~/install-os/files/scripts/zsh-omz.sh
source ~/install-os/files/scripts/lightdm.sh
