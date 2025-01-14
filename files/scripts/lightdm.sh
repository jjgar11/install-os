#!/bin/bash

# Change login manager to lightdm
sudo apt install -y lightdm && sudo dpkg-reconfigure -f noninteractive lightdm
