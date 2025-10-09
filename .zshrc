#!/bin/bash
# -- ############### --
# ---------------------
# --# Z Shell Setup #--
# ---------------------
# -- ############### --

# --------------------------------
# -- Priority
# --------------------------------

# Make the Prompt Cool
# ----------
# Starship installation check
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin >/dev/null 2>&1
    if [ $? -eq 0 ] && [ -f ~/.local/bin/starship ]; then
         echo "Starship installed successfully"
         export PATH=~/.local/bin:$PATH
         echo "export PATH=~/.local/bin:\$PATH" >> ~/.zshrc
   else
     echo "Automatic installation of starship.rs failed. Install manually:"
     echo "curl -sS https://starship.rs/install.sh | sh"
   fi
fi
# ----------

# --------------------------------
# -- Package Manager
# --------------------------------

# Set brew path
# ----------
eval "$(/opt/homebrew/bin/brew shellenv)"
# ----------

# Set Home Var
# ----------
ZINIT_HOME=$HOME/.local/share/zinit/zinit.git
# ----------

# Install if not already
# ----------
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
# ----------

# Source
# ----------
source "${ZINIT_HOME}/zinit.zsh"
# ----------

# --------------------------------
# -- Import Packages
# --------------------------------

# Package List
# ----------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# ----------

# Add in Snippets
# ----------
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::brew
zinit snippet OMZP::command-not-found
# ----------


# Load Completions
# ----------
autoload -U compinit && compinit
zinit cdreplay -q
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/peter.bowman/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
# ----------

# Shell Inits
# ----------
# Zoxide
eval "$(zoxide init zsh)"
# Fzf
eval "$(fzf --zsh)"

# Ssh
# ----------
# Add github.com config if its been erased by sc
CONFIG_BLOCK_WORK=$(cat <<'EOM'
# Work GitHub Account
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_key
EOM
)
if ! grep -qF "Host github.com" ~/.ssh/config; then
    echo "$CONFIG_BLOCK_WORK" >> ~/.ssh/config
    echo "Added GitHub work SSH config block to ~/.ssh/config"
fi
# Start the ssh agent
eval "$(ssh-agent -s)"
# ----------


# --------------------------------
# -- Path Updater 
# --------------------------------
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH
export PATH="$HOME/.local/share/custom_scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# ----------


# --------------------------------
# -- Brew & C Compliation
# --------------------------------
export C_INCLUDE_PATH="/opt/homebrew/include:$C_INCLUDE_PATH"
export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"
export LDFLAGS="-L/opt/homebrew/lib"
export CFLAGS="${CFLAGS} -Wno-incompatible-function-pointer-types"
export CXXFLAGS="${CXXFLAGS} -Wno-incompatible-function-pointer-types"
export OBJC_DISABLE_INITIALIZE_FOR_SECTIONS=YES 
# ----------


# --------------------------------
# -- Editor Settings
# --------------------------------
alias vim='nvim'
export EDITOR=nvim
# and am I using lua?
[[ -f "/Users/$USER/.config/nvim/init.lua" ]] && export VIMINIT="luafile /Users/$USER/.config/nvim/init.lua" 
# ----------

# --------------------------------
# ---- Shell Configuration Files
# --------------------------------

# Alias definitions.
if [ -f "/Users/$USER/.bash_aliases" ]; then
    . "/Users/$USER/.bash_aliases"
fi

# User Defined Functions Import
# I've decided to copy the idea from bash_aliases in order to keep them seperate from here
if [ -f "/Users/$USER/.shell_functions" ]; then
	. "/Users/$USER/.shell_functions"
fi
# These are wrapper functions for various commands I'll have
if [ -f "/Users/$USER/.shell_wrappers" ]; then
	. "/Users/$USER/.shell_wrappers"
fi
# Load Client Sensitive Data 
if [ -f "/Users/$USER/.secrets" ]; then
	. "/Users/$USER/.secrets"
    alias editsecrets='vim /Users/$USER/.secrets && source /Users/$USER/.secrets'
fi

# Define the on_exit functions
if [ -f "/Users/$USER/.bash_exit" ]; then
	trap "/Users/$USER/.bash_exit" EXIT
fi

# ---- End Of Bash Configuration Files ----

# --------------------------------
# Starship.rs
# --------------------------------

# Load Config
# ---------- 
eval "$(starship init zsh)"
# ----------

# --------------------------------
# -- General Settings
# --------------------------------

# History Settings
# ----------
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt append_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_verify

# Case Insentive & Color Completions
# ----------
zstyle ":completion:*" matcher-list 'm:{a-z}={A-Za-z}'
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu no

# FZF integration
# ----------
zstyle ":fzf-tab:complete:exa:*" fzf-preview "ls --color $realpath"
zstyle ":fzf-tab:complete:cd:*" fzf-preview "ls --color $realpath"
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview "ls --color $realpath"
# ----------

# --------------------------------
# ---- Start Of Environment Variables
# --------------------------------
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Dev
# Use mise to version control languages
eval "$(mise activate zsh)"
# ---- End of Environment Variables ----

# --------------------------------
# ---- PROJECT VAR UPDATERS
# --------------------------------

# PYTHONPATH updater 
# ----------
function projectpypath() {
    unset PYTHONPATH
    export PYTHONPATH=$PWD:$(which python)
    echo "Python Path is now: $PYTHONPATH"
}
# ----------

# VPN status line for my prompt
# ----------
function vpnstatus() {
  local vpn_name
  vpn_name=$(scutil --nc list | grep 'Connected' | awk -F '"' '{print $2}')
  if [[ -n "$vpn_name" ]]; then
    echo "$vpn_name"
  fi
}
# ----------

# PKG_CONFIG_PATH for Brew
# ----------
export PKG_CONFIG_PATH="/opt/homebrew/bin/pkg-config:$(brew --prefix icu4c)/lib/pkgconfig:$(brew --prefix curl)/lib/pkgconfig:$(brew --prefix zlib)/lib/pkgconfig"
# ----------


# ---- End Of Project Vars ------


# --------------------------------
# ---- FZF Styling
# --------------------------------

# -- History
# ----------
fzf-history-widget() {
  local selected=$(fc -l 1 | awk '{$1=""; print substr($0,2)}' | fzf --height=40% --reverse --border --ansi \
      --color=fg:#f9f5d7,bg:#1d2021,hl:#d79921,fg:#fbf1c7,bg:#3c3836,hl:#fabd2f \
      --pointer=" " \
      --preview-window="up:1:wrap" \
      --preview="echo {}")

  if [ -n "$selected" ]; then
    BUFFER="$selected" 
    zle accept-line
  fi
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
# ----------
#
# ----------
# ---- EOF ----
# ----------
