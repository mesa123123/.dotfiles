#!/bin/bash
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
[[ $(cat /proc/version | grep -c "microsoft") == 1 ]] && alias uur='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && npm --location=global update'
[[ $(cat /proc/version | grep -c "MANJARO") == 1 ]] && alias uur='sudo pacman -Syu && yay -Syu && sudo pacman -R $(pacman -Qdtq) && yay -R $(yay -Qdtq) && yay -Scc' && alias spacman='sudo pacman' 
#  Programmes etc.
alias gnpm='npm -g'
alias pip='pip3'
alias spip='sudo pip3'
alias dotsync='~/.dotfiles/dfsync.sh -m begin -r no'
alias comppose='docker-compose'
# Hardware Application Commands
alias bluetooth="blueman-manager"
#Fiddily Vim Stuff
if [[ $(dpkg-query -l neovim 2>/dev/null | grep -c "neovim") ]]; then
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

# Spotify Player Commands
alias media_pp='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause'
alias media_next='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next'
alias media_last='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous'


# --------
# Fancy Commands
# --------
# WSLON Commands
[[ $WSLON == "true" ]] && alias cmd="$CMD_HOME"
[[ $WSLON == "true" ]] && alias wsl_desktop='dbus-launch --exit-with-session ~/.xsession'
[[ $WLSON == "true" ]] && alias jupyter-lab='jupyter-lab --no-browser'

# CARGO Utilities
# If batcat is installed use that instead of cat
[[ "$(cargo install --list | grep "bat")" == *"bat"* ]] || [[ $(pacman -Qqe 2>/dev/null | grep -xc "bat") == 1 ]] && alias cat='bat'
# If bottom is installed use that use that instead of top
[[ "$(cargo install --list | grep "bottom")" == *"bottom"* ]] && alias top='btm'
# If tldr is installed use that instead of man
[[ "$(cargo install --list | grep "tealdeer")" == *"tealdeer"* ]] && alias man='tldr'
# If du-dust is installed use that instead
[[ "$(cargo install --list | grep "du-dust")" == *"du-dust"* ]] &&  alias du='dust'
# If Broot is installed map it to the br command
[[ "$(cargo install --list | grep "tre")" == *"tre"* ]] && alias tree='tre'
# If git-delta is installed, use that for diff
[[ $(cargo install --list | grep -c "git-delta") == 1 ]] && alias diff="delta"
# If mcfly is installed tie it to the command
[[ $(cargo install --list | grep -c "mcfly") == 1 ]] && alias mcfly="eval $(mcfly init bash)"
# Certain Terminals get fiddily with TERM settings so this gets around it for kitty at least
[[ ""$TERM == *"kitty"* ]] && alias ssh="kitty +kitten ssh"
