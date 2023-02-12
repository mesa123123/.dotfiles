#!/bin/bash

function wsldevcheck() {
	if [ "${WSLON}" == "true" ]; then
        [[ ! -d ~/dev  ]] && ln -s "$WINHOME"/dev ~/dev
    fi
}

# A function to make a directory for a new project if it isn't already made, only used by other functions
function makedevDir() {
   # Prompt User on Non-existent Directory and ask if they want to create it
   echo "Project "${1}" doesn't currently exist, create project?"
   echo "(y/n)"
   # Store User Input in Variable
   read -r ANSWER
   # If yes, create folder and git repo
   if [ "${ANSWER}" == "y" ]; then 
        mkdir ~/dev/"${1}"
        echo "Project Folder Created, Iniatlize Git Repo?"
        read -r REPOFY
        echo "(y/n)"
        [ "${REPOFY}" == "y" ] && git init ~/dev/"${1}"
        cd ~/dev/"${1}"
   else
       echo "Project not created"
       return 1;
   fi
}

# Function to open a certain development project from the windows dev file
function devhome()
{
    # If theres no link to the dev folder on windows, link it 
    wsldevcheck
    # If no arguement is given simply go to the dev/projects home folder
	if [[ -z "$1" ]]; then
		echo "No project named, please enter one of the following:"	
		ls ~/dev/
        echo "or use -m to create new name of new project"
	#  if i use the cmd switch -m then i can create a new project
    elif [[ "$1" == "-m" ]]; then 
        if [[ -z "$2" ]]; then
            echo "no new project named, please enter name of new project"
            read -r PROJECT_NAME
            makedevDir "${PROJECT_NAME}"    
        else
            makedevDir "$2" 
        fi
	# If I enter the word go, it just goes to the folder	
    elif [[ "$1" == "go" ]]; then
            cd ~/dev/;
	else
		# If the arguement given is show, print out the list of project folders
		if [[ "$1" == "show" || "$1" == "list" ]]; then	
			ls ~/dev/
		# if the arguement given is the name of a project go to that project folder	
		else
            if [ -d ~/dev/"${1}" ]; then cd ~/dev/"${1}" || exit; else echo "No project named ${1} please enter the name of a valid project or use command line switch -m to create one"; fi
            if [[ $? == 1 ]]; then 
                return 1;
            fi
		fi
	fi
}

# Encapsulates a set of commands for one of the tmux development panes in a function of its own
# Probably should be able to sort this out for more environments other than those named "env"
function DvxSendKeys()
{
    ENVPRESENT=~/dev/"${1}"/.venv
    devhome "${1}"
    if [[ -d $ENVPRESENT ]]; then
       source "$ENVPRESENT"/bin/activate
    fi
}

# Function for launching a tmux session for development projects
function dvx() 
{
    wsldevcheck
    if [[ $# -eq 0 ]]; then
        echo "Please enter one of the following:"
        ls ~/dev/
        return 1;
    fi
    if [[ ! -d ~/dev/Projects/"${1}" ]]; then
        makedevDir "${1}"
        if [[ $? == 1 ]]; then
            echo "Project not created, exiting"
            return 1;
        fi
    fi
    tmux new-session -d -s development
    tmux rename-window -t 0 development
    tmux split-window -v 
    tmux select-pane -t 1
    tmux send-keys -t1 DvxSendKeys Space "${1}" Enter
    tmux send-keys -t0 DvxSendKeys Space "${1}" Enter
    tmux send-keys -t0 'vim' Enter 
    tmux send-keys -t1 'clear' Enter
    tmux attach-session -t development:0 -c ~/dev/Projects/"${1}"

}

function newscreen()
{
  XRANDROUTPUT=$(xrandr)
  if [[  "${XRANDROUTPUT}" == *"${2}"* ]]; then
      echo "There is already a screen resolution of this size"
  else
      xrandr --newmode "\"${2}\"" 166.00  1904 2024 2224 2544 1050 1053 1063 1089 -hsync +vsync
      xrandr --addmode $1 "\"${2}\""
  fi
}

# CocFunction for installing
function cocfinstall() {
    npm install $1 --ignore-scripts --no-lockfile --production --legacy-peer-deps
}

# Touchpad control on ubuntu
function tpt() {
    if synclient | grep --quiet 'TouchpadOff             = 0'; then
      synclient TouchpadOff=1
      notify-send Touchpad Disabled
    else
      synclient TouchpadOff=0
      notify-send Touchpad Enabled
    fi
}

# Environment Variable Settings
# ----------------
# The kitty terminal doesn't behave too nicelty 
function standardterm() {
    [[ ! $TERM == *"xterm-256color"* ]] && export TERM=xterm-256color || export TERM=${1}
}
alias kitterm="standardterm xterm-kitty"
# Python Environments Activation
function stenv() {
    ENVFILE=env/bin/activate
    BINFILE=bin/activate
    if [ -f "${ENVFILE}" ]; then
        source ./env/bin/activate
        pip3 install wheel pynvim
        clear
    elif [ -f "${BINFILE}" ]; then
        source ./bin/activate
        pip3 install wheel pynvim
        clear
    else
        echo "Can't find an unamed or env-named virtualenvironment"
    fi
}

# export the functions to the shell session
export -f devhome
export -f dvx
export -f newscreen
export -f stenv
export -f cocfinstall
export -f standardterm
