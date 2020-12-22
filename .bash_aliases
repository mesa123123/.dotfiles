# Directory Commands
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..="cd ../"
alias winhome='cd $WINHOME'
alias learnhome='cd $LEARNHOME'
alias dothome='cd ~/.dotfiles'

# Bash Config Files
alias resetbash='source ~/.bashrc'
alias editbash='vim ~/.bashrc && source ~/.bashrc'
alias editalias='vim ~/.bash_aliases && source ~/.bash_aliases'
alias editfuncs="vim ~/.bash_functions && source ~/.bash_functions"
alias editaptsource='sudo vim /etc/apt/sources.list'
alias editexit="vim ~/.bash_exit && source ~/.bashrc"
alias editvim="vim ~/.vim/.vimrc"
alias edittmux="vim ~/.tmux.conf"

# Package Management
alias uur='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

#  Programmes etc.
alias svim='sudo vim'
alias chrome="/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
alias gnpm='sudo npm -g --proxy=false'
alias unpm='npm --proxy=false'
alias spip='sudo pip3'
alias prpy='pipenv run python'

# Screen Commands
alias tmux="TERM=screen-256color-bce tmux"
alias cls='clear'

# WSL Only Commands
alias wsl_desktop='dbus-launch --exit-with-session ~/.xsession'
