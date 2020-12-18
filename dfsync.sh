#!/bin/bash

# -----------
# [Author] Peter Bowman
#			A script to automatically sync my dotfiles at the start and end of a bash session
# -----------

VERSION=0.1.0
SUBJECT="Dotfile Sync Script"
USAGE="Usage: remote_dotfiles_sync.sh -m args"
LOGFILE=~/.dotfiles/synclogs.log

# ------- Global Script Variables -------

declare -a TRACKEDFILESFORSYNC
TRACKEDFILESFORSYNC=(".bashrc" ".bash_aliases" ".bash_functions" ".bash_exit" ".tmux.conf" ".vim/.vimrc")

# In order to get around a proxy sometimes you gotta start the browser, ergo you need to know where
# your browser is
BROWSERCHROME="/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
BROWSERBRAVE="/c/Users/$USER/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe"
# ------- End of Global Script Variables -------

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

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
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

# This creates subfolders where applicable, i.e. files that are actually stored in a subfolder such as ~/.vim/.vimrc this creates those subfolders forthe client within the home folder and .dotfilesbackup folder 
function create_subfolders()
{
	echo "Creating Subfolder" >> $LOGFILE
	# Split the first arguement given to the function by the `/` character and turn it into an array
	readarray -d / -t subfolders <<< ${1} 	
	# Create a variable to store the partial file path	
	File_Subpath=""	
	# While the array's length is more than nothing do the following
	while [[ ${#subfolders[*]} -gt 0 ]] 
	do
		# Take the first member of the array and pop it off the array's front 
		echo "Code Me Please!"		
		# Add that popped array member to the variable prefixed with a /
		# Check if that folder exists in both ~/.dotfilesbackup and ~/
		# If in either case that folder doesn't exist, create it
		# Repeat the loop
	done
}

# This sets the browser for the client
function set_browser()
{
	if [ "$USER" == "m808752" ]; then
		BROWSER=$BROWSERBRAVE
	else
		BROWSER=$BROWSERCHROME
	fi
	echo "$BROWSER"
}

# This function takes the previous dotfiles, and puts them into the .dotfilesbackup folder, then adds the folders from the local repo to the clients environment
function create_symlink()
{
	# If not, create a dotfiles backup directory (if not already created) 
	if [ ! -d ~/.dotfilesbackup ]; then
			mkdir ~/.dotfilesbackup
	fi
	# Put the named file in a variable
	FILEARG=${1}
	# Filter out subfolders and create them if necessary, this means checking the arguement for the character `/` meaning there is a subfolder structure
	if [[ "$FILEARG" == *"\/"* ]]; then
		create_subfolders $FILEARG
	fi
	# Create a variable that has the relative path to home
	FILEFORSYNC=~/$FILEARG
	# Check if the file exists on the client	
	if [ -f ${FILEFORSYNC} ]; then
		# Check if its not already a symlink to this repo
		if [ -L "${FILEFORSYNC}" ]; then
			# If yes, do nothing	
			return 
		else
			mv ${FILEFORSYNC} ~/.dotfilesbackup/$1
			# Then create a symlink file from this repo	
			ln -s $(pwd)/$FILEARG ${FILEFORSYNC}
		fi
	# If the file doesn't current exist on the client	
	else
		# Create the symlink
		ln -s $(pwd)/$FILEARG ${FILEFORSYNC}
	fi
}


# Check if the cntlm proxy is running on client
function check_if_at_work()
{
	echo "`service cntlm status`"
}

# Check if git access is available >> $LOGFILE
function git_access_check()
{
	echo "Pinging Git" >> $LOGFILE
	PING_GIT=`wget --spider -Sq "https://github.com" 2>&1 | grep "HTTP/" | awk '{print $2}'` >> $LOGFILE
	echo "GIT ping Response ${PING_GIT}" >> $LOGFILE
	[[ ${PING_GIT} -eq 200 ]] && echo true || echo false
}

# Because a proxy needs certain certs to connect to the internet there needs to be a cert refresh in
# order to pull from any git files at the beginning and it seems that launching a browser does that
function start_browser_proxy()
{
	am_i_at_work=`check_if_at_work`
	echo "$am_i_at_work" >> $LOGFILE
	if [[ $am_i_at_work == *"cntlm is running"* ]]; then
		echo "Cntlm Proxy Is Running, Assuming you're at work" >> $LOGFILE
		GIT_ACCESS=`git_access_check`
		echo "GIT ACCESS CHECK $GIT_ACCESS" >> $LOGFILE
		if [[ $GIT_ACCESS == false ]]; then	
			# This command starts the browser in github, somehow the browser saying its cool gets
			# around Zscaler?
			BROWSER=`set_browser`
			"$BROWSER" https://github.com;
		fi
	fi
}	

# --------- End of Reuseable Methods --------

# --------- Business Logic Starts Here -------

# Sync all changes from other clients when things start up
if [[ "${MODE}" == "begin" ]]; then
	# Sync the repo up to date	
	start_browser_proxy >> $LOGFILE
	git -C ~/.dotfiles fetch >> $LOGFILE;
	git -C ~/.dotfiles pull origin master -q >> $LOGFILE;
	for i in "${TRACKEDFILESFORSYNC[@]}"
	do
		create_symlink $i
	done	
fi

# move all changes that have been made during the session to the cloud
if [[ "${MODE}" == "end" ]]; then
	# Get list of manually installed packages for current machine state:
	apt-mark showmanual | sed -e 's/^[ \t]*//' | tr '\n' ' ' > ~/.dotfiles/client_package_list/package_list_$USER
	# Regular Git Push Routine	
	git -C ~/.dotfiles add . >> $LOGFILE
	# DateTime Stamped Commit
	commit_message="Sessions End $(date)"
	echo $commit_message >> $LOGFILE
	git -C ~/.dotfiles commit -m "${commit_message}" >> $LOGFILE
	git -C ~/.dotfiles push origin master -q >> $LOGFILE
fi

# -------- End of Business Logic --------

exit 0