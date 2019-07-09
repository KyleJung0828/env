#!/bin/bash

echo "Copying vimrc..."
cp ../vimrc ~/.vimrc

echo "Sourcing tmux.conf..."
tmux source-file ../tmux.conf

echo "Installing vundle..."
./plugin-install.sh vundle

echo "Installing monokai..."
./plugin-install.sh monokai

echo "Done!"
