#!/bin/bash

# Function to open a certain development project from the windows dev file
function devhome()
{
	# If no arguement is given simply go to the dev/projects home folder
	if [ -z "$1" ]; then
		echo "Please enter one of the following:"	
		ls $WINHOME/dev/Projects
	else
		# If the arguement given is show, print out the list of project folders
		if [ "$1" == "show" ]; then	
			ls $WINHOME/dev/Projects/
		# if the arguement given is the name of a project go to that project folder	
		else	
			cd $WINHOME/dev/Projects/$1
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
	else
		# If the arguement given is show, print out the list of project folders
		if [ "$1" == "show" ]; then	
			ls $WINHOME/dev/Learning/
		# if the arguement given is the name of a project go to that learning folder	
		else	
			cd $WINHOME/dev/Learning/$1
		fi
	fi

# export the functions to the shell session
export -f devhome
export -f learnhome
