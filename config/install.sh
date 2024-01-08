#!/bin/bash

echo -e "${BLUE}Init system settings${C_OFF}"
## Set dark mode
gsettings set org.gnome.shell.ubuntu color-scheme prefer-dark

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions


