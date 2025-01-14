#!/bin/bash

# Change shell from bash to zsh with oh-my-zsh
sudo apt install -y zsh
echo 'Y' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mv ~/.zshrc ~/.zshrc-orig
cp -r ~/.install/files/.rc.d/ ~/.rc.d/
(cat .install/files/zsh_start; cat ~/.zshrc-orig) >  ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
apt_pref='apt' && apt_upgr='upgrade'
sed -i 's/plugins=(git)/plugins=(git z zsh-syntax-highlighting python debian history)/' ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

chsh -s $(which zsh)