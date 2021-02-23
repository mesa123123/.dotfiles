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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[[01;32m\]\u@\h\[[00m\]:\[[01;34m\]\w\[[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\]$PS1"
    ;;
*)
    ;;
esac

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

# --------
# ---- Bash Configuration Files ----
# --------

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
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
fi

# Define the on_exit functions
if [ -f ~/.bash_exit ]; then
	trap ~/.bash_exit EXIT
fi

# ---- End Of Bash Configuration Files ----

# ----------- Revert Path back to the PROFILE output as bashrc tends to be run more than once ------------------------------
if [[ -n "$PROFILE_PATH" ]]; then
    export PATH=$PROFILE_PATH
fi

# ----  WSL Settings ----
# First Check if you are running WSL Environment or not
CATOSRELEASE=$(cat /proc/sys/kernel/osrelease)
# Create and export the WSLON variable to the environment
WSLON=$([[ ${CATOSRELEASE,,} == *"microsoft"* ]] && echo "true" || echo "false")
export WSLON

# Special WSL Paths for Interoperability
if [[ $WSLON == true ]]; then
	export PATH=$PATH:/c/Windows/System32
    # As Powershell is reqiured to run some scripts and is placed stupidly in the win10 filesystem it needs its own special variable
    export POWERSHELL_HOME="/c/Windows/System32/WindowsPowerShell/v1.0"
    export PATH=$PATH:$POWERSHELL_HOME
fi

# Check WSL_VERSION by going through interop channels
if [[ $WSLON == true ]]; then
	RESPONSE=$(uname -r | grep Microsoft > /dev/null && echo "WSL1")
	[[ ${RESPONSE}  == *"1"* ]] && export WSL_VERSION=1 || export WSL_VERSION=2
	cd ~ || exit;
fi
# ---- End of WSL Settings ---- 
# ----

# ---------
# ---- Start Of Environment Variables -----
# ---------

# Universal Environment Variables
export PATH=$PATH:~/.local/bin
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export SCALA_HOME=/usr/share/scala
export SPARK_HOME="/opt/spark"
export SBT_HOME="/usr/bin/sbt"
export PY3_REPO_ROOT="/usr/lib/python3/dist-packages"
export PIP_CONFIG_FILE="$WINHOME/pip.ini"
export PIPENV_VENV_IN_PROJECT=1
export PYSPARK_PYTHON="/usr/bin/python3"
export VIM_INIT='source ~/.vim/.vimrc'
export VIMINIT='source ~/.vim/.vimrc'
export EDITOR='vim'

# Special WSL envvars that would just annoy a pure linux system
if [[ ${WSLON} == true ]]; then
	export CODE_HOME="/c/Users/$USER/AppData/Local/Programs/Microsoft VS Code"
	export REAL_DOCKER_HOME='/mnt/wsl/docker-desktop-data/data'
    export WINHOME="/c/Users/$USER"
    export LEARNHOME="$WINHOME/dev/learning/"
	# Now stuff that differs between versions of WSL 
	if [[ $WSL_VERSION == 1 ]]; then	
		export DOCKER_HOST="tcp://localhost:2375"
	fi
fi



# Home User Environment Variables
if [ "$USER" == "bowmanpete" ]; then
	# User Environment Vars for Home PC	
	export EXERCISM_HOME="/home/$USER/.exercism"
	export ANDROID_HOME="/home/$USER/Android/bin"
	export SSL_CERT_DIR="/etc/ssl/certs"
	export CODE_HOME="/c/Program Files/Microsoft\ VS\ Code/"
	export HADOOP_HOME=/usr/local/hadoop
	# Adding Home User Variables to Path
	export PATH=$PATH:$ANDROID_HOME/emulator
	export PATH=$PATH:$ANDROID_HOME/tools
	export PATH=$PATH:$ANDROID_HOME/tools/bin
	export PATH=$PATH:$ANDROID_HOME/platform-tools
	export PATH=$PATH:/home/$USER/android-studio/bin
	export PATH=$PATH:$EXERCISM_HOME/
	export PATH=$PATH:$HADOOP_HOME/bin
	export PATH=$PATH:$CODE_HOME/bin
	# Environment Variable Modifiers
	# export JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true"
fi

# Work Environment Variables
if [ "$USER" == "m808752" ]; then
	export POLYNOTEHOME="/opt/polynote"
fi

# Appending Variables Variables to Path
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"
export PATH=${PATH}:${SCALA_HOME}/bin
export PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"
export PATH=$PATH:$SBT_HOME
export PATH="$PATH:$CODE_HOME/bin"

# ---- End Of Environment Variables -----

# Work Proxy Settings
if [ "$USER" == "m808752" ] && [[ ${WSLON} == true ]]; then
	export {http,https,ftp}_proxy="http://localhost:3128"
	export {HTTP,HTTPS,FTP}_proxy="http://localhost:3128"
	export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=localhost -Dhttp.proxyPort=3128 -Dhttps.proxyHost=localhost -Dhttps.proxyPort=3128"
fi

# Powerline Setup
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
	  powerline-daemon -q
      POWERLINE_BASH_CONTINUATION=1
      POWERLINE_BASH_SELECT=1
	  source /usr/share/powerline/bindings/bash/powerline.sh
fi


# ---- Automated Shell Commands For Startup ----
# Starting Proxy Services
if [ "$USER" == "m808752" ]; then
	# If the service is already running don't start it up..	
	if [[ "$(service cntlm status)" == *"* cntlm is not running"* ]]; then
		echo "$WORK_PWD"  | sudo -S service cntlm start
	fi
   # if [ "${WSL_VERSION}" == 2 ]; then
   #     echo "$WORK_PWD" | sudo -S echo "${WORK_NAMESERVERS}" >> /etc/resolv.conf
   # fi
fi

# Configure .dotfiles
if [ -f ~/.dotfiles/dfsync.sh ] && [ -z "${TMUX}" ] && [ $SHLVL == 1 ]; then
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

# Set the xdg-open to whatever the browser variable is

# WSL Display Commands
if [[ $WSLON == true ]]; then
	# If you're running wsl send the display to the virtual output	
    WSL2IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
    export WSL2IP
    if [ "${WSL_VERSION}" == 2 ]; then
        export DISPLAY="$WSL2IP":0.0
    else 
        export DISPLAY="127.0.0.1:0.0"
    fi
	export PULSE_SERVER=tcp:"$WSL2IP"
fi

