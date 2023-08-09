#!/bin/bash -x

# -----------
# [Author] Peter Bowman
#			A script to automatically sync my dotfiles at the start and end of a bash session
# -----------

VERSION=0.1.0
SUBJECT="Dotfile Sync Script"
USAGE="Usage: remote_dotfiles_sync.sh -m begin/end -r true/false"
LOGFILE=~/.dotfiles/synclogs.log

# ------- Global Script Variables -------

declare -a TRACKEDFILESFORSYNC
TRACKEDFILESFORSYNC=(".bashrc" ".bash_aliases" ".bash_functions" ".bash_exit" ".tmux.conf"  ".config/nvim" "./.profile")
# If its wsl add the wslbin directory too, the bashrc already has functionality to sort out the wsl_on variable
if [[ $WSLON == true ]] && [[ -f "./wslbin/*" ]]; then
    WSLBINDIR=".wslbin/"
    WSLBINFILES=("$(ls "$WSLBINDIR"*)")
fi

SOURCEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# ------- End of Global Script Variables -------

# -------- Null Switches Method ------
if [ $# == 0 ]; then 
	echo "$USAGE"
	exit 1;
fi
# --------

# --------- Help Text ---------
HELP_MESSAGE="Proper uses of this scripts are:\n\nSwitch -m\n\tbegin:\n\t\tsets up the dotfiles for the client\n\tend:\n\t\tsync up changes to the dotfiles to the github repo -r\n\t checks for ~/.repos file and also syncs up the named local repos with their chosen remotes"

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
	echo -e "$HELP_MESSAGE"
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
    -r|-repo)
    REPOS="$2"
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

# --------- Reusable Methods --------

# Pull Repo functions for start of session
function pullRepo()
{
	git -C "$1" fetch >> "$LOGFILE";
	git -C "$1" pull "$2" "$3" -q >> "$LOGFILE";
}

# NAME: timestamppush
# DESC: Pushes repos that I want updated on all clients to push back to the cloud at the end of the session
# ARGS: $@ (optional):  1, Path to git repo; 2, Remote Repo Name; 3, Remote Branch Name; 
# OUTS: None
function timeStampPush()
{
	# Regular Git Push Routine
	git -C "${1}" add . >> "$LOGFILE"
	# DateTime Stamped Commit
	commit_message="Sessions End $(date)" >> "$LOGFILE"
	# Commit mnad Push
	git -C "${1}" commit -m "$commit_message" -q >> "$LOGFILE"
	git -C "${1}" push -q "${2}" "${3}" >> "$LOGFILE"
}

# NAME: getRepoInfo
# DESC: Takes Repo file and puts in the form of an assocaite array 
# ARGS: $@ (optional): $1, The file path of the repos file
# OUTS: None, but it will echo the lines back to the parent function calling it, best used when assigning something to an array
function getRepoInfo()
{
  # Read ~/.repo file line by line
  while IFS= read -r line; do
    # For each line echo it out to the array calling it 
      if [[ ! "$line" == "#"* ]]; then
          NEWITEM="$line"
          echo "$NEWITEM" | sed 's/ /,/g' | envsubst
      fi
  done < "$1"
}

# --------- End of Reuseable Methods --------

# --------- Business Logic Starts Here -------

# Sync all changes from other clients when things start up
if [[ "$MODE" == "begin" ]]; then
	# Pull the current repo
    pullRepo "$HOME"/.dotfiles origin main -q 
    # To stop the editing of all of these dotfiles from getting too out of hand
    PROFILE_PATH_PRESENT=$(cat ~/.profile | grep "export PROFILE_PATH=\$PATH");
    if [ "$PROFILE_PATH_PRESENT" = "" ]; then
        echo "export PROFILE_PATH=\$PATH" >> ~/.profile
    fi
    # if there are other repos that need to be synced up then pull them too
    if [[ "$REPOS" == "yes" ]]; then
        if [[ -f ~/.repos ]]; then
            REPOLIST=( "$(getRepoInfo "$HOME/.repos")" )
            for REPO in "${REPOLIST[@]}"; do
                REPOArr=( "$(echo "$REPO" | sed 's/,/ /g')" )
                REPODIR="${REPOArr[1]}"
                pullRepo "$REPODIR" "${REPOArr[2]}" "${REPOArr[3]}" && echo "Repo Pulled ${REPOArr[0]}" >> "$LOGFILE"
            done
        else
            echo "REPOS NOT SYNCED, YOU NEED TO CREATE A REPOS FILE!" >> "$LOGFILE"
            exit 1;
        fi
    fi    
fi

# move all changes that have been made during the session to the cloud
if [[ "$MODE" == "end" ]]; then
    # Push Dotfiles
    timeStampPush ~/.dotfiles origin main 
    # Push All Other Git Repos
    if [[ "$REPOS" == "yes" ]]; then
        if [[ -f ~/.repos ]]; then
            REPOLIST=( "$(getRepoInfo "$HOME/.repos")" )
            for REPO in "${REPOLIST[@]}"; do
                REPOArr=( "$(echo "$REPO" | sed 's/,/ /g'i)" )
                timeStampPush "${REPOArr[2]}" "${REPOArr[3]}" "${REPOArr[4]}" && echo "Repo Pulled ${REPOArr[1]}" >> "$LOGFILE" 
            done
        else
            echo "REPOS NOT SYNCED, YOU NEED TO CREATE A REPOS FILE!" >> "$LOGFILE"
            exit 1;
        fi
    fi    
fi

# -------- End of Business Logic --------

exit 0
