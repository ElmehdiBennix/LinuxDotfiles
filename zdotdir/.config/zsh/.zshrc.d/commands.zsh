#!/bin/zsh
###############################################################
# commands.zsh - Aliases and Functions.
################################################################

# =============================================================
# Aliases
# =============================================================

alias g="git"

alias LS="/bin/ls"
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -lh --color=always --group-directories-first --icons --git'
alias la='eza -lAh --color=always --group-directories-first --icons'
alias l='eza -lah --color=always --group-directories-first --icons --git'
alias ldot='eza -ld .* --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -a | grep -E "^\."'

alias tree="eza --icons=always --colour=always --tree"

# Navigation
alias CD="/bin/cd"

# Initialize zoxide and replace cd
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias CAT="/bin/cat"
alias cat="bat --color=always --plain"

alias GREP="/bin/grep"
alias grep="rg"

# System
alias parus="paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S"
alias parur="paru -Qeq | fzf --multi --preview 'paru -Qi {1}' | xargs -ro paru -Rns"

alias update='paru -Syu'
alias search='paru -Ss'
alias install='paru -S'
alias lsearch='paru -Qs'
alias remove='paru -Rns'

alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias backup='sudo timeshift --create --comments "archbtw-backup-$(date +%Y%m%d)"'
alias shutdown='systemctl poweroff'

alias du='dust'

alias code="code --reuse-window"
alias codew="code --new-window"

alias fzff="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias fzfd="find . -type d 2>/dev/null | fzf --height 40% --preview='eza --icons=always --long --tree --level 2 {}'"

alias cppath="realpath $1 | wl-copy"

# tar
alias tarls="tar -tvf"
alias untar="tar -xf"

# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \n    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \n    print (ul.quote_plus(sys.argv[1]))"'

# misc
alias please=sudo
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zconf="cd ${ZDOTDIR:-$HOME/.config/zsh}"
alias zdot='cd ${ZDOTDIR:-~}'
alias zsecrets='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc.d/secrets.zsh'
alias zenv='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc.d/env.zsh'

# =============================================================
# Functions
# =============================================================

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
loadenv() {
  local env_file="${1:-.env}"
  if [ -f "$env_file" ]; then
    source <(grep -v '^#' "$env_file" | sed 's/^/export /')
    echo "✅ Loaded environment variables from '$env_file'"
  else
    echo "❌ Error: '$env_file' not found." >&2
    return 1
  fi
}

# Function to unload environment variables from a .env file
unloadenv() {
  local env_file="${1:-.env}"
  if [ -f "$env_file" ]; then
    for var in $(grep -v '^#' "$env_file" | cut -d'=' -f1);
 do
      unset "$var"
    done
    echo "💨 Unloaded environment variables from '$env_file'"
  else
    echo "❌ Error: '$env_file' not found." >&2
    return 1
  fi
}
