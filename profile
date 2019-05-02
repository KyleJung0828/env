# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ -f "$HOME/.bashrc" ]; then 
    source "$HOME/.bashrc"
fi

if [ -f "$HOME/kyle/env/tmux.conf" ]; then
    tmux source-file "$HOME/kyle/env/tmux.conf"
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

if [ -f /home/kwanghyun/office/build/ccache/ccache.profile ]; then
  source /home/kwanghyun/office/build/ccache/ccache.profile
fi

# export CCACHE_PREFIX="icecc"
export PATH=$PATH:$HOME/office/script
export PATH=$PATH:$HOME/office/script
