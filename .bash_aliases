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
alias editexit="vim ~/.bash_exit && source ~/.bash_exit"
alias editvim="vim ~/.vim/.vimrc"
alias edittmux="vim ~/.tmux.conf"

# Package Management
alias uur='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

#  Programmes etc.
alias svim='sudo vim'
alias gnpm='sudo npm -g'
alias spip='sudo pip3'
alias prpy='pipenv run python'

# Screen Commands
alias tmux="TERM=screen-256color-bce tmux"
alias cls='clear'

# WSL Only Commands
alias wsl_desktop='dbus-launch --exit-with-session ~/.xsession'

# Selenium Commands
if [ -f "/usr/local/bin/seleniumServer.jar" ]; then
   alias seleniumServer="java -jar /usr/local/bin/seleniumServer.jar"
fi
# Fiddily Chrome WSL Stuff
if [ "$WSLON" == "true" ]; then
    if [ "$USER" == "m808752" ]; then
        alias chrome='google-chrome --proxy-server="http://localhost:3128"'
    else    
        alias chrome='/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
    fi
else
    alias chrome='google-chrome'
fi
