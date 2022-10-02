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
alias editsecs="vim ~/.bash_secrets && source ~/.bash_secrets"
alias editaptsource='sudo vim /etc/apt/sources.list'
alias editexit="vim ~/.bash_exit && source ~/.bash_exit"
alias edittmux="vim ~/.tmux.conf"

# Package Management
[[ $(cat /proc/version | grep -c "UBUNTU") == 1 ]] && alias uur='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && npm --location=global update'
[[ $(cat /proc/version | grep -c "MANJARO") == 1 ]] && alias uur='sudo pacman -Syu && sudo pacman -Qtdq | sudo pacman -Rns - && sudo yay -Syu' && alias spacman='sudo pacman' 
#  Programmes etc.
alias gnpm='npm -g'
alias pip='pip3'
alias spip='sudo pip3'
alias prpy='pipenv run python'
alias dotsync='~/.dotfiles/dfsync.sh -m begin -r no'
#Fiddily Vim Stuff
if [[ $(pacman -Qqe neovim 2>/dev/null | grep -c "neovim") == 1 ]]; then
    alias vim='nvim'
    alias svim='sudo nvim'
    alias oldvim='\vim'
    [[ -f "/home/$USER/.config/nvim/init.lua" ]] && alias editvim="vim /home/${USER}/.config/nvim/init.lua" || alias editvim="vim /home/${USER}/.vim/.vimrc"
else
    alias svim='sudo vim'
fi

# Screen Commands
alias tmux="TERM=screen-256color-bce tmux"
alias cls='clear'

# Application Commands
alias bluetooth="blueman-manager"

# Chromium Stuff
if [[ $(pacman -Syu chromium-browser 2>/dev/null | grep -c "chromium-browser") == 1 ]]; then
    alias chrome='chromium-browser'
else
    alias chrome='chromium'
fi

# WSL Only Commands
alias wsl_desktop='dbus-launch --exit-with-session ~/.xsession'

# --------
# Fancy Commands
# --------
if [[ $WSLON == "true" ]]; then
    alias cmd="$CMD_HOME"
fi

# If batcat is installed use that instead of cat
if [[ "$(cargo install --list | grep "bat")" == *"bat"* ]]; then
    alias cat='bat'
else
    if [[ $(pacman -Qqe 2>/dev/null | grep -c "bat") == 1 ]]; then
            alias cat='bat'
    fi
fi
# If bottom is installed use that use that instead of top
if [[ "$(cargo install --list | grep "bottom")" == *"bottom"* ]]; then
    alias top='btm'
fi
# If tldr is installed use that instead of man
if [[ "$(cargo install --list | grep "tealdeer")" == *"tealdeer"* ]]; then
    alias man='tldr'
fi
# If du-dust is installed use that instead
if [[ "$(cargo install --list | grep "du-dust")" == *"du-dust"* ]]; then
    alias du='dust'
fi
# If Broot is installed map it to the br command
if [[ "$(cargo install --list | grep "broot")" == *"broot"* ]]; then
    alias broot='br'
    alias tree='br'
fi
# If git-delta is installed, use that for diff
[[ $(cargo install --list | grep -c "git-delta") == 1 ]] && alias diff="delta"
# If Gping is about use that instead of ping
if [[ "$(pacman -Qqe | grep "gping")" == *"gping"* ]]; then
    alias ping='gping'
fi

# Certain Terminals get fiddily with TERM settings so this gets around it for kitty at least
if [[ "${TERM}" == *"kitty"* ]]; then
    alias ssh="kitty +kitten ssh"
fi
