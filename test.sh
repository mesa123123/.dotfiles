#!/bin/bash

TRACKEDFILESFORSYNC=(".bashrc" ".bash_aliases" ".bash_functions" ".bash_exit" ".tmux.conf" ".vim/.vimrc" ".config/coc/extensions/package.json" ".vim/coc-settings.json" ".vim/UltiSnips" ".vim/spell" ".config/nvim")


for i in "${TRACKEDFILESFORSYNC[@]}";
do
	# Put the named file in a variable
	FILEARG="${i}"
    # Create a relative link in the home directory
    if [ -d "${FILEFORSYNC}" ]; then
        # If the file for sync is a folder then remove the last part of the relative home link, for some reason this is a quirk with the ln -s command. There's likely a better way to do this but I can't be bothered learning about string manipulation in shell right now...
       echo "Before: ${FILEARG}"
       IFS="/" read -r -a fileArr <<< ${FILEARG}
       unset fileArr[${#fileArr[@]}-1];
       FILEFORSYNC="~/$(IFS="/";echo "${fileArr[*]}";IFS=$' \t\n')/"
       echo "After ${FILEFORSYNC}"
    else
        # Regular Files should be all good
       FILEFORSYNC=~/$FILEARG
    fi
	# Check if the file exists on the client	
	if [ -f "${FILEFORSYNC}" ] | [ -d "${FILEFORSYNC}" ]; then
		# Check if its not already a symlink to this repo
		if [ -L "${FILEFORSYNC}" ]; then
			# If yes, do nothing	
		    echo "If yes, do nothing"
        else
			# Then create a symlink file from this repo	
            echo "${FILEFORSYNC} If there is not already a symlink"
		fi
	# If the file doesn't current exist on the client	
	else
		# Create the symlink
		echo "${FILEFORSYNC} If the file doesn't exist on the client"
	fi
done
