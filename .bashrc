# -------------------------------- 
# ------- BASH_PROFILE -----------
# --------------------------------

# ~/.bashrc: executed by bash(1) for non-login shells. see /usr/share/doc/bash/examples/startup-files (in the 
# package bash-doc) for examples
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Find Distro Info
DIST_INFO=$(cat /proc/version)
export DIST_INFO
# set variable identifying the chroot you work in (used in the prompt below)
[[ $(echo "$DIST_INFO" | grep --color=auto -c "UBUNTU") == 1 ]] && [ "${debian_chroot:-}" = "" ] && [ -r /etc/debian_chroot ] && debian_chroot=$(cat /etc/debian_chroot)

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    (xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ "$force_color_prompt" != "" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=no
    fi
fi
if [[ $(echo "$DIST_INFO" | grep --color=auto -c "UBUNTU") == 1 ]]; then
    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[[01;32m\]\u@\h\[[00m\]:\[[01;34m\]\w\[[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
# export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# --------
# ---- Priority Environment Configs ----
# --------

# ----------- PROFILE Revert ------------------------------
if [[ -n "$PROFILE_PATH" ]]; then
    export PATH=$PROFILE_PATH
fi

# ---- Node Env ----
# Putting Node here will help similar for node configs to load properly
[ ! -d /home/"$USER"/.npm-global ] && mkdir /home/"$USER"/.npm-global 
export NPM_CONFIG_PREFIX=/home/$USER/.npm-global
# --------
# ---- Deno Env ----
if [ -d /home/"$USER"/.deno ]; then 
    export DENO_INSTALL="/home/pbowman/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
fi

# --------
# ---- Bash Configuration Files ----
# --------

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . /home/"$USER"/.bash_aliases
fi

# Bash Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# User Defined Functions Import
# I've decided to copy the idea from bash_aliases in order to keep them seperate from here
if [ -f ~/.bash_functions ]; then
	. ~/.bash_functions
fi

# Load Client Sensitive Data 
if [ -f ~/.bash_secrets ]; then
	. ~/.bash_secrets
    alias editsecrets='vim ~/.bash_secrets && source ~/.bash_secrets'
fi

# Define the on_exit functions
if [ -f ~/.bash_exit ]; then
	trap ~/.bash_exit EXIT
fi

# ---- End Of Bash Configuration Files ----

# ---- Function that adds text to files if they are not currently there ----
configadd() {
    grep -qxF "${2}" "$1" || echo "${2}" >> "$1"
}

# ---------
# ---- Start Of Environment Variables -----
# ---------

# Universal Environment Variables
export PATH=$PATH:~/local/bin
export PATH=$PATH:~/.local/bin
# Language Servcer Protocol
export PATH=$PATH:~/lsp
# JAVA
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
# SCALA
export SCALA_HOME=/usr/share/scala
export SPARK_HOME=/opt/spark
export PYSPARK_DRIVER_PYTHON=jupyter-lab
export PYSPARK_DRIVER_PYTHON_OPTS='--no-browser --port=8889'
export SBT_HOME="/usr/bin/sbt"
# RUST
export CARGO_HOME="/home/$USER/.cargo"
# PYTHON
export PY3_REPO_ROOT="/usr/lib/python3/dist-packages"
export PIPENV_VENV_IN_PROJECT=1
export PYSPARK_PYTHON="/home/$USER/.pyenv/shims/python"
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# CURL
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_DIR=/usr/local/share/ca-certificates
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# Special WSL envvars that would just annoy a pure linux system
if [[ ${WSLON} == true ]]; then
	export CODE_HOME="/c/Users/$USER/AppData/Local/Programs/Microsoft VS Code"
	export REAL_DOCKER_HOME='/mnt/wsl/docker-desktop-data/data'
    export PIP_CONFIG_FILE="$WINHOME/pip.ini"
	# Now stuff that differs between versions of WSL 
	if [[ $WSL_VERSION == 1 ]]; then	
		export DOCKER_HOST="tcp://localhost:2375"
        export BROWSER="explorer.exe"
    fi
    # Helps Vagrant along though Vagrant is messy at best over wsl so avoid unless using wsl 1
    export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
    export VARANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/c/Users/${USER}/VirtualBox VMs"
fi

# Editor Settings VIM or NEOVIM?
# Set Nvim default to 0
NVIM=0
# If on Manjaro
[[ $(echo "$DIST_INFO" | grep -c "MANJARO") == 1 ]] && [[ $(pacman -Qqe 2>/dev/null | grep -c "neovim") == 1 ]] && NVIM=1
# If on Ubuntu
[[ $(echo "$DIST_INFO" | grep -c "UBUNTU") == 1 ]] && [[ $(dpkg-query -l neovim 2>/dev/null | grep -c "neovim") == 1 ]] && NVIM=1
#i If on WSL
[[ $(echo "$DIST_INFO" | grep -c "microsoft") == 1 ]] && [[ $(dpkg-query -l neovim 2>/dev/null | grep -c "neovim") == 1 ]] && NVIM=1

if [[ ${NVIM} == 1 ]]; then  
    export EDITOR=nvim
    # and am I using lua?
    [[ -f "/home/$USER/.config/nvim/init.lua" ]] && export VIMINIT="luafile /home/$USER/.config/nvim/init.lua" || export VIMINIT="source /home/$USER/.config/nvim/init.vim"
else
    export EDITOR=vim
    export VIMINIT="source /home/$USER/.vim/.vimrc"
fi

# Home User Environment Variables
if [ "$USER" == "bowmanpete" ]; then
	# User Environment Vars for Home PC	
	export EXERCISM_HOME="/home/$USER/.exercism"
	export ANDROID_SDK_ROOT="/usr/lib/android-sdk"
	# Adding Home User Variables to Path
	export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
    export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin
	export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
	export PATH=$PATH:$EXERCISM_HOME/
	export PATH=$PATH:$HADOOP_HOME/bin
	export PATH=$PATH:$CODE_HOME/bin
    # No LEARNHOME variable in home dir 
    if [ -d "/home/${USER}/dev/learning/" ]; then
        export LEARNHOME="/home/${USER}/dev/learning/"
    else
        if [ -d "/home/${USER}/Learning/" ]; then
        export LEARNHOME="/home/${USER}/Learning/"
        fi
    fi
fi


# Appending Variables Variables to Path
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"
export PATH="${PATH}:${SCALA_HOME}/bin"
export PATH=$PATH:$SBT_HOME
export PATH="$PATH:$CODE_HOME/bin"
export PATH="$PATH:$GEM_HOME/bin"
export PATH="$PATH:/c/Program Files/Oracle/VirtualBox"
export PATH="$PATH:$NPM_CONFIG_PREFIX/bin"
export PATH="$PYENV_ROOT/bin:$PATH"

# ---- End Of Environment Variables -----



# ---- Automated Shell Commands For Startup ----
# Helpful for settingn up certain things that may or may not be installed
check_command() {
    command
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}


# Pyenv Setup
eval "$(pyenv init -)"  
eval "$(pyenv virtualenv-init -)"

# Powerline Setup
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source /usr/share/powerline/bindings/bash/powerline.sh
fi

# spicetify setup
spice_installed=$(check_command spicetify)
if [ "$spice_installed" == "0" ]; then
    spicetify config current_theme Jackdaw
    spicetify apply
fi


# WSL Display Commands
if [[ $WSLON == true ]]; then
	# If you're running wsl send the display to the virtual output	
    if [ "$WSL_VERSION" == 2 ]; then
        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
        export LIBGL_ALWAYS_INDIRECT=1
    else
        export DISPLAY=127.0.0.1:0.0
    fi
fi

# ---- End Of Automated Shell Commands on Startup -----

# ----------------
# End Of bashrc
# ----------------
export PATH=$PATH:/home/bowmanpete/.spicetify
