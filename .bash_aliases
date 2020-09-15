# Directory Commands
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias winhome='cd $WINHOME'

# Bash Config Files
alias resetbash='source ~/.bashrc'
alias editbash='sudo vim ~/.bashrc && source ~/.bashrc'
alias editalias='sudo vim ~/.bash_aliases && source ~/.bashrc'
alias editfuncs="vim ~/.bash_functions && source ~/.bashrc"
alias editaptsource='sudo vim /etc/apt/sources.list'
alias editexit="vim ~/.bash_exit && source ~/.bashrc"
alias editvim="vim ~/.vim/.vimrc"

# Package Management
alias uur='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

#  Programmes etc.
alias svim='sudo vim'
alias chrome="/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
alias gnpm='sudo npm -g --proxy=false'
alias unpm='npm --proxy=false'
alias spip='sudo pip3'

# Screen Commands
alias tmux="TERM=screen-256color-bce tmux"
alias cls='clear'

