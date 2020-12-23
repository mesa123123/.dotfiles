#!/bin/bash

function wsldevcheck() {
	if [ "${WSLON}" == "true" ]; then
        [[ ! -d ~/dev  ]] && ln -s $WINHOME/dev ~/dev
    fi
}

# A function to make a directory for a new project if it isn't already made, only used by other functions
function makeDevDir() {
   # Prompt User on Non-existent Directory and ask if they want to create it
   echo "Project ${1} doesn't currently exist, create project?"
   echo "(y/n)"
   # Store User Input in Variable
   read ANSWER
   # If yes, create folder and git repo
   if [ "${ANSWER}" == "y" ]; then 
        mkdir ~/dev/projects/"${1}"
        echo "Iniatlize Git Repo?"
        read REPOFY
        echo "(y/n)"
        [ "${REPOFY}" == "y" ] && git init ~/dev/projects/"${1}"
        cd ~/dev/projects/"${1}"
    else 
        exit 0;
    fi
}

# Function to open a certain development project from the windows dev file
function devhome()
{
    wsldevcheck
    # If no arguement is given simply go to the dev/projects home folder
	if [ -z "$1" ]; then
		echo "Not a current project, please enter one of the following:"	
		ls ~/dev/Projects
        echo "Or enter name of new project"
	# If I enter the word go, it just goes to the folder	
	elif [ "$1" == "go" ]; then
		cd ~/dev/
	else
		# If the arguement given is show, print out the list of project folders
		if [ "$1" == "show" ]; then	
			ls ~/dev/Projects/
		# if the arguement given is the name of a project go to that project folder	
		else
            [ -d ~/dev/Projects/"${1}" ] && cd ~/dev/Projects/"${1}" || makeDevDir $1
            
		fi
	fi
}

# Encapsulates a set of commands for one of the tmux development panes in a function of its own
function DvxSendKeys()
{
    PIPFILELOC=~/dev/projects/${1}/Pipfile
    devhome ${1}
    if [[ -f $PIPFILELOC ]]; then
       pipenv install 
       pipenv shell devhome ${1} && clear
    fi
}

# Function for launching a tmux session for development projects
function dvx() 
{
    wsldevcheck
    if [ $# -eq 0 ]; then
        echo "Please enter one of the following:"
        ls ~/dev/Projects/
        exit 1;
    fi
    if [[ ! -d ~/dev/Projects/"${1}" ]]; then
            makeDevDir $1
    fi
    wait
    tmux new-session -d -s Development
    tmux rename-window -t 0 Development
    tmux split-window -v 
    tmux send-keys -t0 devhome Space ${1} Enter 
    tmux send-keys -t0 'vim' Enter 
    tmux select-pane -t 1
    tmux send-keys -t1 DvxSendKeys Space ${1} Enter
    tmux wait-for command-finished
    tmux attach-session -t Development:0 -c ~/dev/Projects/"${1}"
}


# export the functions to the shell session
export -f devhome
export -f dvx
