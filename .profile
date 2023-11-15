# $HOME/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if $HOME/.bash_profile or $HOME/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Force terminal type info
export TERMINFO="/usr/share/terminfo"

# Client Specific Settings
if [ -f $HOME/.profile_secrets ]; then
	. $HOME/.profile_secrets
fi

# Put the Distro in its own Variable
# ----------------
DISTRO=$(lsb_release -si)
export DISTRO 

# WSL System Interop Setttings
# ----------------
# WSL Check - Note the bash rc exports the env variable
CATOS=$(cat /proc/sys/kernel/osrelease)
# Create and export the WSLON variable to the environment
export WSLON=$([[ ${CATOS,,} == *"microsoft"* ]] && echo "true" || echo "false")

# Special WSL Paths for Interoperability in cmd lines
if [[ ${WSLON} == "true" ]]; then
    export WINHOME="/mnt/c/Users/${USER}/"
	export PATH=$PATH:"/c/Windows/System32/"
    export CMD_HOME="/c/Windows/System32/cmd.exe"
    # As Powershell is reqiured to run some scripts and is placed stupidly in the win10 filesystem it needs its own special variable
    export POWERSHELL_HOME="/c/Windows/System32/WindowsPowerShell/v1.0"
    export PATH=$PATH:$POWERSHELL_HOME
fi
# Check WSL_VERSION by going through interop channels
if [[ $WSLON == true ]]; then
	RESPONSE=$(uname -r | grep Microsoft > /dev/null && echo "WSL1")
	[[ ${RESPONSE}  == *"1"* ]] && export WSL_VERSION=1 || export WSL_VERSION=2
    if [[ $WSL_VERSION == 2 ]]; then
        export WINIP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
    fi
fi
# ---- End of WSL Settings ---- 

# Configure .dotfiles
if [ -f $HOME/.dotfiles/sync.sh ] && [ -z "${TMUX}" ] && [ $SHLVL == 1 ] && [ -z "${VIMRUNTIME}" ]; then
    # The sync and the bashrc have to work together as there are scripts that allow wsl to work alongside
    # windows so the client needs to know what to add to the path and what not to in order properly 
    # configure dotfiles on the client
    if [[ $WSLON == true ]]; then
        export PATH="$PATH:$HOME/.wslbin"
        [ -f $HOME/.repos ] && $HOME/.dotfiles/sync.sh -m begin -r yes >> $HOME/.dotfiles/synclogs.log || $HOME/.dotfiles/sync.sh -m begin -r no >> $HOME/.dotfiles/synclogs.log &
    else
        [ -f $HOME/.repos ] && $HOME/.dotfiles/sync.sh -m begin -r yes >> $HOME/.dotfiles/synclogs.log || $HOME/.dotfiles/sync.sh -m begin -r no >> $HOME/.dotfiles/synclogs.log &
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

# If rust packages are about add them to path
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# Setup Pyenv to deal with multiple python versions
if [ -d "$HOME/.pyenv" ] ; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
# Save the Profile Path Here
export PROFILE_PATH=$PATH

# Load Bash Specifics
# ---------------- 

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
. "$HOME/.cargo/env"
