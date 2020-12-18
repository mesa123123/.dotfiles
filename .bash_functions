#!/bin/bash

# Function to open a certain development project from the windows dev file
function devhome()
{
	# If no arguement is given simply go to the dev/projects home folder
	if [ -z "$1" ]; then
		echo "Please enter one of the following:"	
		ls $WINHOME/dev/Projects
	# If I enter the word go, it just goes to the folder	
	elif [ "$1" == "go" ]; then
		cd $WINHOME/dev/
	else
		# If the arguement given is show, print out the list of project folders
		if [ "$1" == "show" ]; then	
			ls $WINHOME/dev/Projects/
		# if the arguement given is the name of a project go to that project folder	
		else	
			cd $WINHOME/dev/Projects/"${1}"
		fi
	fi
}

# Function to open learning project from the learning home
function learnhome()
{
	# If no arguement is given simply go to the dev/learning home folder
	if [ -z "$1" ]; then
		echo "Please enter one of the following:"	
		ls $WINHOME/dev/Learning/
	# If the arguement is the word go, simply go to the folder	
	elif [ "$1" == "go" ]; then
		cd $WINHOME/dev/learning/
	else
		# If the arguement given is show, print out the list of project folders
		if [ "$1" == "show" ]; then	
			ls $WINHOME/dev/Learning/
		# if the arguement given is the name of a project go to that learning folder	
		else	
			cd $WINHOME/dev/Learning/"${1}"
		fi
	fi
}

# Function for launching a tmux session for development projects
# DvxSendKeys
# DESC:  
# ARGS: $@ (optional): 
# OUTS: 
function DvxSendKeys()
{
    PIPFILELOC=$WINHOME/dev/projects/${1}/Pipfile
    devhome ${1}
    if [[ -f $PIPFILELOC ]]; then
       pipenv install 
       pipenv shell devhome ${1} && clear
    fi
}


function dvx() 
{
    if [ $# -eq 0 ]; then
        echo "Please enter one of the following:"
        ls $WINHOME/dev/Projects/
    else
        PIPFILELOC=$WINHOME/dev/projects/${1}/Pipfile
        tmux new-session -d -s Development
        tmux rename-window -t 0 Development
        tmux split-window -v 
        tmux send-keys -t0 devhome Space ${1} Enter 
        tmux send-keys -t0 'vim' Enter 
        tmux select-pane -t 1
        tmux send-keys -t1 DvxSendKeys Space ${1} Enter
        tmux attach-session -t Development:0 -c $WINHOME/dev/Projects/"${1}"
    fi
}


# export the functions to the shell session
export -f devhome
export -f learnhome
export -f dvx
