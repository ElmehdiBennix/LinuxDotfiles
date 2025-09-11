#########################################################################
# ZINIT
#########################################################################

# Source Pywal colors
# source "${XDG_CACHE_HOME:-$HOME/.cache}/wal/colors.sh"

#zinit plugin mannager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

#########################################################################
# THEME
#########################################################################

zinit ice depth=1; zinit light romkatv/powerlevel10k

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#########################################################################
# AUTOCOMP
#########################################################################

autoload -Uz compinit
compinit
zinit cdreplay -q

#########################################################################
# TAB COMPLETIONS
#########################################################################

zinit ice depth=1; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light Aloxaf/fzf-tab

# Completion settings:
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza --icons=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:$color7,fg+:$color0
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Set up the completers to use for completion.
# _expand: Expand arguments.
# _complete: Complete command arguments.
# _ignored: Ignore certain completions.
# _approximate: Provide approximate completions.
zstyle ':completion:*' completer _expand _complete _ignored _approximate

# Set the completion menu to display with a maximum of 2 items visible at once.
zstyle ':completion:*' menu select=2

# Customize the prompt shown while scrolling through the completion menu.
# %S and %s enable and disable bold formatting respectively; %p shows the position.
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Command to display the list of processes for completion suggestions.
# This will show all processes for the current user.
zstyle ':completion:*:processes' command 'ps -au$USER'

# Disable sorting for completion options. This can be useful if you prefer the original order.
zstyle ':completion:complete:*:options' sort false

# Set up fzf-tab to use the query string from user input when completing _zlua commands.
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# Command for displaying process information during completion.
# This lists the PID, user, command name, and full command with wider output.
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"

# Configure fzf-tab for the `kill` command.
# This sets extra options for the completion of the 'kill' command,
# including a preview of the command being executed for the selected PID.
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview='$extract ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap


#########################################################################
# ZSH PLUGGINGS
#########################################################################

zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions

#########################################################################
# ZSH snippets
#########################################################################

zinit snippet OMZP::git
zinit snippet OMZP::cp
zinit snippet OMZP::common-aliases
zinit snippet OMZP::colored-man-pages
# zinit snippet OMZP::dotenv
# zinit snippet OMZP::docker
# zinit snippet OMZP::copyfile
# zinit snippet OMZP::copypath

#########################################################################
# history settings
#########################################################################

HISTSIZE=4000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

#########################################################################
# KeyBindings
#########################################################################

# bindkey '^w' history-search-backward
# bindkey '^s' history-search-forward
# bindkey "\e[1;3C" forward-word
# bindkey "\e[1;3D" backward-word

#########################################################################
# aliases
#########################################################################

alias CODE="/bin/code"
alias code="code --reuse-window"
alias tree="eza --icons=always --colour=always --tree"
alias LS="/bin/ls"
alias ls="eza --icons=always --colour=always"
alias la="ls -la"
alias CD="/bin/cd"
alias cd="z"
alias CAT="/bin/cat"
alias cat="bat --color=always --plain"
alias grep="rg"
alias size="dust -d 1"
alias zshrc="vim ~/.zshrc"
alias f="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias d="find . -type d 2>/dev/null | fzf --height 40% --preview='eza --icons=always --long --tree --level 2 {}'"
# alias cpfile="copyfile"
# alias cppath="copypath"

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
    echo "❌ Error: '$env_file' not found." >&2
    return 1
  fi
}

#########################################################################
# source externals
#########################################################################

source <(fzf --zsh)
eval "$(zoxide init zsh)"

if [[ -f "$HOME/.cache/matugen/tty_colors.sh" ]]; then
    source "$HOME/.cache/matugen/tty_colors.sh"
fi

export GEMINI_API_KEY="AIzaSyDpVgFAZLRza3miBf-baz16ZkaJzOAyhIc"
export PATH="$PATH:$HOME/.local/bin:$HOME/.local/scripts"

fastfetch
