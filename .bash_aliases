# --------------------------------
# Bash Aliases
# --------------------------------

# Directory Commands - eza
# --------
# If eza is installed use that over ls
[[ "$(cargo install --list | grep -c "eza")" -ge 1 ]] && {
    alias eza='eza -hgx --icons=always --git'
    alias ls='eza -hgx --icons=always --git'
    alias la='eza -hgxa --icons=always --git'
    alias ll='eza -lgxh'
    alias lal='eza -lgxha'
    alias treea='eza -Tlhgxa'
    alias tree='eza -Tlhgx'
} 
# If not use regular ls aliases
[[ "$(cargo install --list | grep -c "eza")" -le 0 ]] && {
    alias ll='ls --color -AalF'
    alias la='ls --color -A'
    alias l='ls --color -CF'
    echo "Couldn't find eza, installing..." && cargo install eza
}
alias .="pwd"
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias ......="cd ../../../../../"
alias winhome='cd $WINHOME'
alias learnhome='cd $LEARNHOME'
alias dothome='cd ~/.dotfiles'
# --------
#
# Config File Edits
# --------
[[ $(echo "$SHELL" | grep -c zsh) == 1 ]] && {
    alias resetshell='source ~/.zshrc' && alias editshell='vim ~/.zshrc && source ~/.zshrc'
}
[[ $(echo "$SHELL" | grep -c bash) == 1 ]]  &&  {
    alias resetbash='source ~/.bashrc' && alias editbash='vim ~/.bashrc && source ~/.bashrc'
}

alias editfuncs="vim ~/.shell_functions && source ~/.shell_functions"
alias editalias='vim ~/.bash_aliases && source ~/.bash_aliases'
alias editsecs="vim ~/.bash_secrets && source ~/.bash_secrets"
alias editaptsource='sudo vim /etc/apt/sources.list'
alias editexit="vim ~/.bash_exit && source ~/.bash_exit"
alias edittmux="vim ~/.config/tmux/tmux.conf"
alias editkitty="vim ~/.config/kitty/kitty.conf"
alias editwez="vim ~/.wezterm.lua"
alias editgit="vim ~/.gitconfig"
alias editssh="vim ~/.ssh/config"
alias editstarship="vim ~/.config/starship.toml"
alias editmise="vim ~/.config/mise/config.toml"

# --------
editkeys() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: Open Karabiner-Elements configuration file in Vim
        vim ~/.config/karabiner/karabiner.json
        launchctl stop org.pqrs.karabiner.karabiner_console_user_server
        launchctl start org.pqrs.karabiner.karabiner_console_user_server
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux: Open XFCE4 keyboard configuration file in Vim
        vim ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboards.xml
    else
        echo "Unsupported OS: $OSTYPE"
        echo "Please use the command \`editalias\` and add elif [[ \"\$OSTYPE\" == \"$OSTYPE\"* ]]; then condition to editkeys function"
    fi
}
# --------

# Editor Stuff
# --------
if [[ ! $(echo uname | grep -c "Darwin") == 1 ]]; then 
    [[ -f "$HOME/.config/nvim/init.lua" ]] && alias editvim="vim $HOME/.config/nvim/init.lua" || alias editvim="vim $HOME/.vim/.vimrc" 
else
    [[ -f "$HOME/.config/nvim/init.lua" ]] && alias editvim="vim $HOME/.config/nvim/init.lua" || alias editvim="vim $HOME/.vim/.vimrc"
fi

if [[ $(dnf list installed 2>/dev/null | grep -c "neovim") -ge 1 ]]; then
    alias vim='nvim' && alias svim='sudo nvim' && alias oldvim='\vim' 
else
    alias svim='sudo vim' 
fi
# --------

# Package Management
# --------
if [[ $(uname | grep -c "Linux") == 1 ]]; then
    [[ $(cat /proc/version | grep -c "UBUNTU") == 1 ]] && alias uur='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && npm --location=global update'
    [[ $(cat /proc/version | grep -c "microsoft") == 1 ]] && alias uur='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && npm --location=global update'
    [[ $(cat /proc/version | grep -c "MANJARO") == 1 ]] && alias uur='sudo pacman -Syu --noconfirm && yay --noconfirm -Syu && sudo pamac update --no-confirm && sudo pamac clean --no-confirm && sudo pacman --noconfirm -R $(pacman -Qdtq) ' && alias spacman='sudo pacman' 
    [[ $(cat /proc/version | grep -c "Red Hat") == 1 ]] && alias uur='sudo dnf update -y && sudo dnf upgrade -y && sudo dnf autoremove -y'
elif [[ $(uname | grep -c "Darwin") == 1 ]]; then
    alias uur='brew update && brew upgrade && brew cleanup && npm --location=global update && cargo install-update -a'
fi
# --------

#  Language Specific Package MGMT etc.
# --------
alias gnpm='npm -g'
alias pip='python -m pip'
alias spip='sudo python -m pip'
alias dotsync='~/.dotfiles/dfsync.sh -m begin -r no'
alias compose='docker compose'
alias db='databricks'
# --------

# Screen Commands
# --------
alias tmux="TERM=screen-256color-bce tmux"
alias cls='clear'
# --------

# Spotify Player Commands
# --------
alias media_pp='spotify playback play-pause'
alias media_next='spotify playback next'
alias media_last='spotify playback previous'
# --------

# WSLON Commands
# --------
[[ $WSLON == "true" ]] && [[ -n "$CMD_HOME" ]] && alias cmd="$CMD_HOME"
[[ $WSLON == "true" ]] && alias wsl_desktop='dbus-launch --exit-with-session ~/.xsession'
[[ $WLSON == "true" ]] && alias jupyter-lab='jupyter-lab --no-browser'
# ----------


# CARGO Utilities
# ----------
# If batcat is installed use that instead of cat
# Function to make things less messy
cargocheck ()
{
    if [[ "$(cargo install --list | grep "${1}")" == *"${1}"* ]]; then
        if [[ "${3}" = "" ]]; then
            alias "${2}"="${1}"
        else
            alias "${2}"="${3}"
        fi
    else
	    cargo install "${1}"
    fi
}
cargocheck bat cat
cargocheck fd-find find fd
cargocheck mise asdf
cargocheck gping ping
cargocheck tidy-viewer tv
cargocheck bottom top btm
cargocheck tealdeer man tldr
cargocheck du-dust du dust
cargocheck git-delta diff delta 
cargocheck ripgrep grep "rg --no-ignore"
cargocheck cargo-update cargo-update "cargo install-update -a"

# If zoxide is installed use that over cd
[[ "$(cargo install --list | grep -c "zoxide")" -ge 1 ]] && {
    [[ $(uname | grep -c "Darwin") == 1 ]] && {
        alias cd='z'
        alias cdi='zi' 
    } || {
        eval "$(zoxide init bash --no-cmd)"
        alias cd='__zoxide_z' 
        alias cdi="__zoxide_zi"
    }
}
# --------

# Jira Cli Commands
# ----------
alias jalias='cat ~/.bash_aliases | grep jira_'
alias jira_now="jira issues list --assignee \$(jira me) --status \"Progress\" --plain --no-headers"
alias jira_subs="jira issues list --assignee \$(jira me) -t \"Sub-task\" --status \"~Done\" --status \"~Irrelevant\" --plain --no-headers"
alias jira_next="jira issues list --assignee \$(jira me) --status \"~Done\" --status \"~Irrelevant\" --plain --no-headers"
alias jira_me="jira issues list --assignee \$(jira me) --plain --no-headers"
alias jira_epic="jira issues list --assignee \$(jira me) -t Epic --plain --no-headers" 
alias jira_children="jira issues list -t \"Sub-task\" -P"
alias jira_bug="jira issues create --assignee \$(jira me) -P \$(jira issues list --assignee \$(jira me) -t Epic --plain --no-headers --paginate 0:1 | awk '{print \$2}') -t Bug"
alias jira_task="jira issues create --assignee \$(jira me) -P \$(jira issues list --assignee \$(jira me) -t Epic --plain --no-headers --paginate 0:1 | awk '{print \$2}') -t Task"
alias jira_move="jira issues move"
start_task()
{
 jira issues move ${1} 'In Progress'
}
alias jira_start="start_task"
# ----------

# Git Aliases
# ----------
# Functions
function git_remote_name() {
    local remote_name
    remote_name=$(git remote | command egrep -o '(upstream|origin)' | tail -1 2>/dev/null)

    if [[ -z "$remote_name" ]]; then
        remote_name=$(git remote | head -1 2>/dev/null)

        if [[ -z "$remote_name" ]]; then
            command echo "Error: No remotes found in this repository." 1>&2
            return 1
        fi
    fi
    command echo "$remote_name"
    return 0
}
function git_default_branch() {
    local remote_name
    remote_name=$(git_remote_name)
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    git remote show "$remote_name" | command awk '/HEAD branch/ {print $NF}'
    return 0
}
# Aliases
alias g='git'
alias galias='cat ~/.bash_aliases | grep git'
alias gs='git status --short'
alias gd='git diff'
alias gdf='git diff --name-only'
alias gdom='git diff $(git_remote_name) $(git_default_branch)'
alias gdfom='git diff $(git_remote_name) $(git_default_branch) --name-only'
alias gr='git reset --hard'
alias grh='git reset --hard head'
alias grom='git reset --hard @{u}'
alias gRom='git restore --source=$(git_remote_name)/$(git_default_branch)'
alias gR='git restore'
alias ga='git add'
alias gu='git fetch && git pull $(git_remote_name) $(git_default_branch)'
alias gb='git branch'
alias gba='git branch -a'
alias gbD='git branch -D'
alias gC='git checkout'
alias gCb='git checkout -b'
alias gc='git commit '
alias gcm='git commit -m'
alias gl='git log'
alias gld='git dog'
alias glg='git graph'
alias gmt='git mergetool'
# ----------


# GitHub Cli Commands
# ----------
alias gh_check="gh run list -b \$(git branch --show-current) --limit 1"
alias pr="gh pr"
# ----------

# NordVpn Commands
# --------
alias norduk="nordvpn connect United_Kingdom London"
# --------

# Terminal Flavours
# --------
[[ ""$TERM == *"kitty"* ]] && alias ssh="kitty +kitten ssh"
# --------

# --------
# EndofAlias
