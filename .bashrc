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
# ---- Priority Environment Configs ----
# --------

# ----------- PROFILE Revert ------------------------------
if [[ ! -z "$PROFILE_PATH" ]]; then
    export PATH=$PROFILE_PATH
fi

# ---- Node Env ----
# Putting Node here will help similar for node configs to load properly
[ ! -d /home/$USER/.npm-global ] && mkdir /home/$USER/.npm-global 
export NPM_CONFIG_PREFIX=/home/$USER/.npm-global
# Rust Broot Package
if [ -f  ~/.config/broot/launcher/bash/br ]; then
    source ~/.config/broot/launcher/bash/br
fi
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
    alias editsecrets='vim ~/.bash_secrets && source ~/.bash_secrets'
fi

# Define the on_exit functions
if [ -f ~/.bash_exit ]; then
	trap ~/.bash_exit EXIT
fi

# ---- End Of Bash Configuration Files ----

# ---- Function that adds text to files if they are not currently there ----
configadd() {
    grep -qxF "${2}" $1 || echo "${2}" >> $1
}


# Check WSL_VERSION by going through interop channels
if [[ $WSLON == true ]]; then
	RESPONSE=$(uname -r | grep Microsoft > /dev/null && echo "WSL1")
	[[ ${RESPONSE}  == *"1"* ]] && export WSL_VERSION=1 || export WSL_VERSION=2
    if [[ $WSL_VERSION == 2 ]]; then
        export WINIP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
    fi
    cd ~ || exit;
fi
# ---- End of WSL Settings ---- 
# ----

# ---------
# ---- Start Of Environment Variables -----
# ---------

# Universal Environment Variables
export PATH=$PATH:~/local/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/lsp
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export SCALA_HOME=/usr/share/scala
export SPARK_HOME="/opt/spark"
export SBT_HOME="/usr/bin/sbt"
export CARGO_HOME="/home/$USER/.cargo"
export PY3_REPO_ROOT="/usr/lib/python3/dist-packages"
export PIPENV_VENV_IN_PROJECT=1
export PYSPARK_PYTHON="/usr/bin/python3"
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_DIR=/usr/local/share/ca-certificates
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Chef Setup adds chef workstation stuff to the environment variables as it tends to break a lot of stuff with the terminals, its best to only use chef when its needed

# Special WSL envvars that would just annoy a pure linux system
if [[ ${WSLON} == true ]]; then
	export CODE_HOME="/c/Users/$USER/AppData/Local/Programs/Microsoft VS Code"
	export REAL_DOCKER_HOME='/mnt/wsl/docker-desktop-data/data'
    export WINHOME="/c/Users/$USER"
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
if [[ $(dpkg-query -l neovim 2>/dev/null | grep -c "neovim") == 1 ]]; then
    export EDITOR=nvim
    export VIMINIT='source /home/$USER/.config/nvim/init.vim'
else
    export EDITOR=vim
    export VIMINIT='source /home/$USER/.vim/.vimrc'
fi

# Home User Environment Variables
if [ "$USER" == "bowmanpete" ]; then
	# User Environment Vars for Home PC	
	export EXERCISM_HOME="/home/$USER/.exercism"
	export ANDROID_HOME="/usr/lib/android-sdk"
    export ANDROID_SDK="/usr/lib/android-sdk"
    export SDKMANAGER_OPTS='"-Dcom.android.sdklib.toolsdir=$APP_HOME" -XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
	# Adding Home User Variables to Path
	export PATH=$PATH:$ANDROID_HOME/platform-tools
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/tools/bin
	export PATH=$PATH:$EXERCISM_HOME/
	export PATH=$PATH:$HADOOP_HOME/bin
	export PATH=$PATH:$CODE_HOME/bin
    # No LEARNHOME variable in home dir 
    export LEARNHOME="/home/${USER}/dev/learning/"
fi


# Appending Variables Variables to Path
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"
export PATH=${PATH}:${SCALA_HOME}/bin
export PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"
export PATH=$PATH:$SBT_HOME
export PATH="$PATH:$CODE_HOME/bin"
export PATH="$PATH:$GEM_HOME/bin"
export PATH="$PATH:$(which solargraph)"
export PATH="$PATH:/c/Program Files/Oracle/VirtualBox"
export PATH="$PATH:$NPM_CONFIG_PREFIX/bin"


# Chef Setup adds chef workstation stuff to the environment variables as it tends to break a lot of stuff with the terminals, its best to only use chef when its needed
export PATH="$PATH:/opt/chef-workstation/bin:/home/${USER}/.chefdk/gem/ruby/2.7.0/bin:/opt/chef-workstation/embedded/bin:/opt/chef-workstation/gitbin"
export GEM_ROOT="/opt/chef-workstation/embedded/lib/ruby/gems/2.7.0"
export GEM_HOME="/home/${USER}/.chefdk/gem/ruby/2.5.0"
export GEM_PATH="/home/${USER}/.chefdk/gem/ruby/2.5.0:/opt/chef-workstation/embedded/lib/ruby/gems/2.5.0"
_chef_comp() {
    local COMMANDS="exec env gem generate shell-init install update push push-archive show-policy diff export clean-policy-revisions clean-policy-cookbooks delete-policy-group delete-policy undelete describe-cookbook provision"
    COMPREPLY=($(compgen -W "$COMMANDS" -- ${COMP_WORDS[COMP_CWORD]} ))
}
complete -F _chef_comp chef



# ---- End Of Environment Variables -----

# Powerline Setup
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
	  powerline-daemon -q
      POWERLINE_BASH_CONTINUATION=1
      POWERLINE_BASH_SELECT=1
	  source /usr/share/powerline/bindings/bash/powerline.sh
fi


# ---- Automated Shell Commands For Startup ----

# WSL Display Commands
if [[ $WSLON == true ]]; then
	# If you're running wsl send the display to the virtual output	
    if [ "${WSL_VERSION}" == 2 ]; then
        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
        export LIBGL_ALWAYS_INDIRECT=1
    else
        export DISPLAY=127.0.0.1:0.0
    fi
fi

complete -C /usr/bin/terraform terraform
