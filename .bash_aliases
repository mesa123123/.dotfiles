#!/bin/bash
# Directory Commands
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..="cd ../"
alias .-="cd -"
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
[[ $(cat /proc/version | grep -c "MANJARO") == 1 ]] && alias uur='sudo pacman -Syu --noconfirm && yay --noconfirm -Syu && sudo pamac update --no-confirm && sudo pamac clean --no-confirm && sudo pacman --noconfirm -R $(pacman -Qdtq) ' && alias spacman='sudo pacman' 
[[ $(cat /proc/version | grep -c "Red Hat") == 1 ]] && alias uur='sudo dnf update -y && sudo dnf upgrade -y && sudo dnf autoremove -y'
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
alias media_pp='spotify playback play-pause'
alias media_next='spotify playback next'
alias media_last='spotify playback previous'


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
[[ $(cargo install --list | grep -c "git-delta") -ge 1 ]] && alias diff="delta"
# If tidy-viewer is installed map to alias
[[ $(cargo install --list | grep -c "tidy-viewer") -ge 1 ]] && alias tv="tidy-viewer"
# If ripgrep is available use that
[[ "$(cargo install --list | grep -c "ripgrep")" -ge 1 ]] && alias grep='rg --no-ignore'
# If rtx-cli is installed use that over asdf
[[ "$(cargo install --list | grep -c "rtx-cli")" -ge 1 ]] && alias asdf='rtx'
# Certain Terminals get fiddily with TERM settings so this gets around it for kitty at least
[[ ""$TERM == *"kitty"* ]] && alias ssh="kitty +kitten ssh"
