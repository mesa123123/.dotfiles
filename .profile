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


# Configure .dotfiles
if [ -f ~/.dotfiles/dfsync.sh ] && [ -z "${TMUX}" ] && [ $SHLVL == 1 ] && [ -z "${VIMRUNTIME}" ]; then
    # The dfsync and the bashrc have to work together as there are scripts that allow wsl to work alongside
    # windows so the client needs to know what to add to the path and what not to in order properly 
    # configure dotfiles on the client
    if [[ $WSLON == true ]]; then
        export PATH="$PATH:~/.wslbin"
        [ -f ~/.repos ] && ~/.dotfiles/dfsync.sh -m begin -r yes >> ~/.dotfiles/synclogs.log || ~/.dotfiles/dfsync.sh -m begin -r no >> ~/.dotfiles/synclogs.log &
    else
        [ -f ~/.repos ] && ~/.dotfiles/dfsync.sh -m begin -r yes >> ~/.dotfiles/synclogs.log || ~/.dotfiles/dfsync.sh -m begin -r no >> ~/.dotfiles/synclogs.log &
    fi
fi


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PROFILE_PATH=$PATH 

if [ $USER == "m808752" ] && [ -z "${TMUX}" ]; then
	WSLMOUNT=c
	eval "$(ssh-agent -s)"
  	ssh-add ~/.ssh/id_rsa
    ssh-add /$WSLMOUNT/users/$USER/.ssh/id_rsa
fi

. "$HOME/.cargo/env"
