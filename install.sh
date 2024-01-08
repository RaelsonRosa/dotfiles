#!/bin/bash

set -e

# system utilities
dotfiles/install.sh

# apt packages
apt/install.sh

# config 
config/install.sh
