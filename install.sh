#!/bin/bash

chmod +x ~/.install/files/scripts/*.sh

source ~/.install/files/scripts/essentials.sh
sudo ~/.install/files/scripts/sudoers.sh
source ~/.install/files/scripts/utils.sh
source ~/.install/files/scripts/pyenv.sh
source ~/.install/files/scripts/ssh-config.sh
source ~/.install/files/scripts/zsh-omz.sh
source ~/.install/files/scripts/lightdm.sh
