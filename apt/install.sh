#!/usr/bin/env bash


echo "${BLUE}Welcome! Let's start setting up your system. It could take more than 10 minutes, be patient${C_OFF}"

# Test to see if user is running with root privileges.
if [[ "${UID}" -ne 0 ]]
then
 echo "${RED}Must execute with sudo or root${C_OFF}" >&2
 exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
C_OFF='\033[0m'        # Reset Color


## Get script directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## Ubuntu version (number)
system="`lsb_release -rs`"

## Active icon theme
activeTheme=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")

REMOVE_APT=(
  yelp*
  gnome-logs
  seahorse
  gnome-contacts
  geary
  libreoffice*
  gnome-weather
  ibus-mozc
  mozc-utils-gui
  gucharmap
  simple-scan
  popsicle
  popsicle-gtk
  totem*
  lm-sensors*
  xfburn
  xsane*
  hv3
  exfalso
  parole
  quodlibet
  xterm
  redshift*
  drawing
  hexchat*
  thunderbird*
  transmission*
  transmission-gtk*
  transmission-common*
  webapp-manager
  celluloid
  hypnotix
  rhythmbox*
  librhythmbox-core10*
  rhythmbox-data
  mintbackup
  mintreport
  aisleriot
  gnome-mahjongg
  gnome-mines
  quadrapassel
  gnome-sudoku
  cheese*
  pitivi
  gnome-sound-recorder
  remmina*
  gimp*
  zorin-windows-app-support-installation-shortcut
  firefox-esr
  yelp*
  gnome-logs
  seahorse
  gnome-contacts
  geary
  gnome-weather
  ibus-mozc
  mozc-utils-gui
  gucharmap
  simple-scan
  popsicle
  popsicle-gtk
  totem*
  lm-sensors*
  xfburn
  xsane*
  hv3
  exfalso
  parole
  quodlibet
  xterm
  redshift*
  drawing
  hexchat*
  thunderbird*
  transmission*
  transmission-gtk*
  transmission-common*
  webapp-manager
  celluloid
  hypnotix
  rhythmbox*
  librhythmbox-core10*
  rhythmbox-data
  mintbackup
  mintreport
  aisleriot
  gnome-mahjongg
  gnome-mines
  quadrapassel
  gnome-sudoku
  pitivi
  gnome-sound-recorder
  remmina*
)

PROGRAMS_APT=(
	## System 
  ffmpeg
  net-tools
  software-properties-common
  apt-transport-https
  build-essential
  openssh-server 

  ## CLI
  git
  htop
  neofetch
  curl
  wget

  ## Fonts
  fonts-firacode

  ## Gnome
  chrome-gnome-shell
  dconf-editor
  gnome-shell-extensions
  gnome-shell-extension-manager
  gnome-tweaks
  autokey-common
  autokey-gtk

  ## Apps
  code
  vlc
  gcc
  g++
  make
  tmux
)

# Ensure system is up to date and upgrade
sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get full-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'

echo -e "${BLUE}Removing bloatware...${C_OFF}"
for program_name in ${REMOVE_APT[@]}; do
	if dpkg -l | grep -q $program_name; then # If program is installed
		echo -e "${YELLOW}	[REMOVING] - $program_name ${C_OFF}"

		sudo apt remove "$program_name" -y -q
	fi
done
echo -e "${GREEN}Bloatware removed${C_OFF}"

echo -e "${BLUE}Installing programs with apt...${C_OFF}"
for program_name in ${PROGRAMS_APT[@]}; do
	if ! dpkg -l | grep -q $program_name; then # If program is not installed
		echo -e "${YELLOW}	[INSTALLING] - $program_name ${C_OFF}"

		sudo apt install "$program_name" -y -q
	fi
done

echo -e "${BLUE}Programs installeds${C_OFF}"

# Just in case
sudo apt install -y --fix-broken --install-recommends


## Remove junk and update
echo -e "${YELLOW}Updating, upgrading and cleaning system...${C_OFF}"
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y

## Checklist
echo -e "\nInstalled APT's:"
for program_name in ${PROGRAMS_APT[@]}; do
	if dpkg -l | grep -q $program_name; then 
		echo -e "	${GREEN}[INSTALLED] - $program_name ${C_OFF}"
	else
		echo -e "	${RED}[NOT INSTALLED] - $program_name ${C_OFF}"
	fi
done

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt install -y brave-browser
echo "	${GREEN}[INSTALLED] - BRAVE Browser ${C_OFF}"

echo 'Installing Google Chrome'
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
echo "	${GREEN}[INSTALLED] - Chrome Browser ${C_OFF}"


echo
echo "############################################"
echo -e "${GREEN}System and Programs - Done${C_OFF}"
echo "############################################"




