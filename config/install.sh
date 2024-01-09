#!/bin/bash

echo -e "${BLUE}Init system settings${C_OFF}"
## Set dark mode
gsettings set org.gnome.shell.ubuntu color-scheme prefer-dark

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions


wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf &&
wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf &&
wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf &&
wget https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf

sudo mkdir -p /usr/share/fonts/truetype/custom
sudo mv 'MesloLGS NF Bold Italic.ttf' /usr/share/fonts/truetype/custom/
sudo mv 'MesloLGS NF Bold.ttf' /usr/share/fonts/truetype/custom/
sudo mv 'MesloLGS NF Italic.ttf' /usr/share/fonts/truetype/custom/
sudo mv 'MesloLGS NF Regular.ttf' /usr/share/fonts/truetype/custom/

sudo fc-cache -f -v