#!/bin/bash

# Process Command Switches
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
# Sync Mode Switch	
	-m|--MODE)
	MODE="$2"
	shift # past argument
	shift # past value
	;;
# All other switches
	*)
	POSITIONAL+=("$1") # save it in an array for later
	shift # past argument
	;;
esac
done

# Sync all changes from other clients when things start up
if [[ "${MODE}" == "begin" ]]; then
	echo "Startup"
fi

# move all changes that have been made during the session to the cloud
if [[ "${MODE}" == "end" ]]; then
	# Regular Git Push Routine	
	git -C ~/.dotfiles add .
	# DateTime Stamped Commit
	commit_message="Sessions End $(date)"
	echo $commit_message
	git -C ~/.dotfiles commit -m "${commit_message}"
	git -C ~/.dotfiles push origin master
fi


