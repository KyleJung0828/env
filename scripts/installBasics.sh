#!/bin/bash

rm -rf backup

mkdir backup
mv ~/.vimrc backup/vimrc.bak

rm -rf ~/.vimrc
rm -rf ~/.vim
rm -rf vim-monokai

echo "Copying profile..."
cp ../profile ~/.profile

echo "Copying bashrc..."
cp ../bashrc_debian ~/.bashrc

echo "Sourcing tmux.conf..."
tmux source-file ../tmux.conf

echo "Installing vundle..."
./plugin-install.sh vundle

echo "Installing monokai..."
./plugin-install.sh monokai

echo "Done!"
