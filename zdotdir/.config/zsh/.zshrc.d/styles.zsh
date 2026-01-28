#!/bin/zsh
###############################################################
# styles.zsh - Zstyle settings for completions and plugins.
###############################################################

# Completion settings:
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# Set up the completers to use for completion.
zstyle ':completion:*' completer _expand _complete _ignored _approximate

# Set the completion menu to display with a maximum of 2 items visible at once.
zstyle ':completion:*' menu select=2

# Customize the prompt shown while scrolling through the completion menu.
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Command to display the list of processes for completion suggestions.
zstyle ':completion:*:processes' command 'ps -au$USER'

# Disable sorting for completion options.
zstyle ':completion:complete:*:options' sort false

# Command for displaying process information during completion.
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"

# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza --icons=always $realpath'

# custom fzf flags
zstyle ':fzf-tab:*' fzf-flags --color=fg:$COLOR_7,fg+:$COLOR_0
# To make fzf-tab follow FZF_DEFAULT_OPTS.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Configure fzf-tab for the `kill` command.
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview='ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
