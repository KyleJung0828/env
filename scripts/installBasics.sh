#!/bin/bash

rm -rf backup

mkdir backup
mv ~/.vimrc backup/vimrc.bak

rm -rf ~/.vimrc
cp ../files/vimrc ~/.vimrc

cp ../files/gdbinit ~/.gdbinit

rm -rf ~/.vim/colors
rm -rf vim-monokai

echo "Copying profile..."
cp ../files/profile ~/.profile
source ~/.profile

echo "Copying bashrc..."
cp ../files/bashrc_debian ~/.bashrc
source ~/.bashrc

echo "Sourcing tmux.conf..."
tmux source-file ../files/tmux.conf

echo "Installing vundle..."
./plugin-install.sh vundle

echo "Installing monokai..."
./plugin-install.sh monokai

echo "Installing ycm..."
./plugin-install.sh ycm

echo "Done!"
