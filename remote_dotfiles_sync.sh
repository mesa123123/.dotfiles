#!/bin/bash

# -----------
# [Author] Peter Bowman
#			A script to automatically sync my dotfiles at the start and end of a bash session
# -----------

VERSION=0.1.0
SUBJECT="Dotfile Sync Script"
USAGE="Usage: remote_dotfiles_sync.sh -m args"

# -------- Script Running LOCK ---------
LOCKFILE=/tmp/${SUBJECT}.lock

if [ -f "$LOCKFILE" ]; then
	echo "Script is already running"
	exit
fi

trap "rm -f $LOCKFILE" EXIT
touch $LOCKFILE
# --------- End Of Script Running Lock -------


# -------- Null Switches Method ------
if [ $# == 0 ]; then 
	echo $USAGE
	exit 1;
fi
# --------

# --------- Help Text ---------
HELP_MESSAGE="Proper uses of this scripts are:\n\nSwitch -m\n\tbegin:\n\t\tsets up the dotfiles for the client\n\tend:\n\t\tsync up changes to the dotfiles to the github repo"

if [[ "$1" == "help" || "$1" == "--h" ]]; then
	echo -e "${HELP_MESSAGE}"
	exit 0;
fi
# --------- End of Help Text ---------

# --------- Process Command Switches ---------
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
# Sync Mode Switch	
	-m|-mode)
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
# --------- End of Command Switch Processes ---------

# --------- Reuseable Methods --------

function create_symlink()
{
	# Put the named file in a variable
	FILEFORSYNC="~/$1"
	# Check if its not already a symlink to this repo
	if [ -L "$FILEFORSYNC" ]; then
		# If yes, do nothing	
		return 
	else
		# If not, create a dotfiles backup directory (if not already created) 
		if [! -d "~/.dotfilesbackup"]; then
			mkdir "~/.dotfilesbackup"
		fi
		# Move the non-symlinked file to the backup directory
		mv $FILEFORSYNC ~/.dotfilesbackup/$1
		# Then create a symlink file from this repo	
		ln -s ./$1 $FILEFORSYNC
	fi
}


# --------- End of Reuseable Methods --------

# --------- Business Logic Starts Here -------

# Create an Array for the files that are to be moved to symlinks when the files are synced
declare -a TRACKEDFILESFORSYNC
TRACKEDFILESFORSYNC=(".bashrc" ".bash_aliases" ".bash_functions" ".bash_exit")

# Sync all changes from other clients when things start up
if [[ "${MODE}" == "begin" ]]; then
	# Sync the repo up to date	
	git -C ~/.dotfiles fetch
	git -C ~/.dotfiles pull origin master
	
	
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

# -------- End of Business Logic --------

exit 0
