#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

# single character aliases - be sparing!
# alias _=sudo
# alias l=ls
# alias g=git

# # mask built-ins with better defaults
# alias vi=vim

# # more ways to ls
# alias ll='ls -lh'
# alias la='ls -lAh'
# alias ldot='ls -ld .*'


# # tar
# alias tarls="tar -tvf"
# alias untar="tar -xf"

# # find
# alias fd='find . -type d -name'
# alias ff='find . -type f -name'

# # url encode/decode
# alias urldecode='python3 -c "import sys, urllib.parse as ul; \
#     print(ul.unquote_plus(sys.argv[1]))"'
# alias urlencode='python3 -c "import sys, urllib.parse as ul; \
#     print (ul.quote_plus(sys.argv[1]))"'

# # misc
# alias please=sudo
# alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
# alias zdot='cd ${ZDOTDIR:-~}'
















#################
#### ALIASES ####
#################

# CLI Utility
alias LS="/bin/ls"
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons --git --time-style=long-iso'
alias la='eza -a --color=always --group-directories-first --icons'
alias l='eza -lah --color=always --group-directories-first --icons --git --time-style=long-iso'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -a | grep -E "^\."' # Show only dotfiles

alias tree="eza --icons=always --colour=always --tree"

alias h='history'

# Navigation
alias CD="/bin/cd"
alias cd="z"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias CAT="/bin/cat"
alias cat="bat --color=always --plain"

alias GREP="/bin/grep"
alias grep="rg"

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcl='git clone'
alias gl='git log --oneline'
alias gd='git diff'
alias gpush='git push'
alias gpull='git pull'

# System
alias parus="paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S"
alias parur="paru -Qeq | fzf --multi --preview 'paru -Qi {1}' | xargs -ro paru -Rns"
alias install='paru -S'
alias update='paru -Syu'
alias search='paru -Ss'
alias lsearch='paru -Qs'
alias remove='paru -Rns'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias backup='sudo timeshift --create --comments "archbtw-backup-$(date +%Y%m%d)"'
alias shutdown='systemctl poweroff'
alias du='dust'

alias CODE="/bin/code"
alias code="code --reuse-window"

alias zshrc="vim ~/.zshrc"

alias f="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias d="find . -type d 2>/dev/null | fzf --height 40% --preview='eza --icons=always --long --tree --level 2 {}'"

alias cppath="realpath $1 | wl-copy"

#########################################################################
# functions
#########################################################################

zelat() {
 local session
 session=$(zellij ls -r | fzf --ansi --height 10% --reverse --style=full | awk {'print $1'})
 zellij attach $session
}

# clone personel repos
ghf() {
    repo=$(gh repo list | awk '{print $1}' | fzf --height 40% --reverse --preview "gh repo view {}" --preview-window=up:50%:wrap )
    if [[ -n "$repo" ]]; then
        gh repo clone $repo
    fi
}

# Folder search with fzf and eza tree preview
c() {
  local dir
  dir=$(find $HOME -type d 2>/dev/null | fzf --height 40% --preview="eza --icons=always --long --tree --level 2 {}")
  [ -n "$dir" ] && z "$dir"  # Change to `cd "$dir"` if not using z
}

# Function to load environment variables from a .env file
# Usage: loadenv [filename]
# Defaults to .env if no filename is provided
loadenv() {
  local env_file
  if [ -n "$1" ]; then
    env_file="$1"
  else
    env_file=".env"
  fi

  if [ -f "$env_file" ]; then
    # Use the robust method to export vars, handling comments and spaces
    source <(grep -v '^#' "$env_file" | sed 's/^/export /')
    echo "✅ Loaded environment variables from '$env_file'"
  else
    echo "❌ Error: '$env_file' not found." >&2
    return 1
  fi
}

# Function to unload environment variables from a .env file
# Usage: unloadenv [filename]
# Defaults to .env if no filename is provided
unloadenv() {
  local env_file
  if [ -n "$1" ]; then
    env_file="$1"
  else
    env_file=".env"
  fi

  if [ -f "$env_file" ]; then
    # Unset the variables by reading their names from the file
    # `cut -d'=' -f1` gets everything before the first '='
    for var in $(grep -v '^#' "$env_file" | cut -d'=' -f1); do
      unset "$var"
    done
    echo "💨 Unloaded environment variables from '$env_file'"
  else
    return 1
    echo "❌ Error: '$env_file' not found." >&2
  fi
}

extract() {
    if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xvf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
    else
    echo "'$1' is not a valid file"
    fi
}
