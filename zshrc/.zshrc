#########################################################################
# ANTIDOTE
#########################################################################

# Automatically install Antidote if it's not already present
if [ ! -d "$HOME/.antidote" ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi

# Source Antidote's generated static plugin file for max performance
# If the static file doesn't exist yet, source Antidote directly to make its commands available
if [[ -f ~/.zsh_plugins.zsh ]]; then
  source ~/.zsh_plugins.zsh
else
  source ~/.antidote/antidote.zsh
fi

#########################################################################
# AUTOCOMP
#########################################################################

autoload -Uz compinit
compinit

#########################################################################
# TAB COMPLETIONS
#########################################################################

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
# source externals
#########################################################################

source <(fzf --zsh)
eval "$(zoxide init zsh)"



fastfetch
