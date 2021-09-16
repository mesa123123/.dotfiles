# $HOME/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if $HOME/.bash_profile or $HOME/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
# Because you'll need to add /usr to the path variable this needs to be there
echo $PATH >> /home/bowmanpete/output.output
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# WSL Check - Note the bash rc exports the env variable
CATOSRELEASE=$(cat /proc/sys/kernel/osrelease)
# Create and export the WSLON variable to the environment
WSLON=$([[ ${CATOSRELEASE,,} == *"microsoft"* ]] && echo "true" || echo "false")
# Configure .dotfiles
if [ -f $HOME/.dotfiles/dfsync.sh ] && [ -z "${TMUX}" ] && [ $SHLVL == 1 ] && [ -z "${VIMRUNTIME}" ]; then
    # The dfsync and the bashrc have to work together as there are scripts that allow wsl to work alongside
    # windows so the client needs to know what to add to the path and what not to in order properly 
    # configure dotfiles on the client
    if [[ $WSLON == true ]]; then
        export PATH="$PATH:$HOME/.wslbin"
        [ -f $HOME/.repos ] && $HOME/.dotfiles/dfsync.sh -m begin -r yes >> $HOME/.dotfiles/synclogs.log || $HOME/.dotfiles/dfsync.sh -m begin -r no >> $HOME/.dotfiles/synclogs.log &
    else
        [ -f $HOME/.repos ] && $HOME/.dotfiles/dfsync.sh -m begin -r yes >> $HOME/.dotfiles/synclogs.log || $HOME/.dotfiles/dfsync.sh -m begin -r no >> $HOME/.dotfiles/synclogs.log &
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

# export PROFILE_PATH=$PATH 

if [ $USER == "m808752" ] && [ -z "${TMUX}" ]; then
	WSLMOUNT=c
	eval "$(ssh-agent -s)"
  	ssh-add $HOME/.ssh/id_rsa
fi

. "$HOME/.cargo/env"
