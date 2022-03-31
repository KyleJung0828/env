#!/bin/bash

OSName=""

promptOSChoice() {
read -p "Choose OS (mac/windows) : " prompt
  if [ $prompt == "mac" ] || [ $prompt == "windows" ]; then
    OSName=$prompt
  else
    echo "Enter correct OS name (mac/linux)!"
    promptOSChoice
  fi
}

promptOSChoice

echo "installing package manager..."
if [ $OSName == "mac" ]; then
  if [ ! -e /usr/local/Homebrew ]; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

echo "installing tmux..."
if [ $OSName == "mac" ]; then
  brew install tmux
else
  apt-get install tmux
fi
echo "Sourcing tmux.conf..."
tmux source-file ../files/tmux.conf

echo "Copying vimrc..."
rm -rf ~/.vimrc
if [ $OSName == "mac" ]; then
  cp ../files/vimrc_mac ~/.vimrc
else
  cp ../files/vimrc_linux ~/.vimrc
fi

echo "Copying bash_profile..."
rm -rf ~/.bash_profile
if [ $OSName == "mac" ] || [ $OSName == "linux" ]; then
  cp ../files/bash_profile ~/.bash_profile

echo "Installing vundle..."
./plugin-install.sh vundle

echo "Installing monokai..."
rm -rf ~/.vim/colors
rm -rf vim-monokai
./plugin-install.sh monokai

echo "Done!"
