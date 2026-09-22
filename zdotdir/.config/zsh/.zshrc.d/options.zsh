#!/bin/zsh
###############################################################
# options.zsh - Shell options, history, and key bindings.
###############################################################

# =============================================================
# history settings
# =============================================================

# Ensure history directory exists (XDG Compliance)
_zsh_history_dir="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
[[ -d "$_zsh_history_dir" ]] || mkdir -p "$_zsh_history_dir"

HISTSIZE=10000
HISTFILE="$_zsh_history_dir/history"
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# =============================================================
# key bindings
# =============================================================

# use ctrl + shift + left/right to highlight text backward/forward
# bindkey '^[[1;6D' backward-word
# bindkey '^[[1;6C' forward-word

# #use backslash for delete char backward
# bindkey '^?' backward-delete-char
# # use delete for delete char forward
# bindkey '^[3~' delete-char

# # Use Ctrl+Left/Right to navigate words
# bindkey '^[[1;5C' forward-word
# bindkey '^[[1;5D' backward-word

# # Use Ctrl+Backspace to delete the previous word
# bindkey '^H' backward-kill-word
# # use Ctrl+Delete to delete the next word
# bindkey '^[3;5~' kill-word


# # bind fn + Left/Right to move to beginning/end of line
# bindkey '^[[1;5D' beginning-of-line
# bindkey '^[[1;5C' end-of-line

# # Use fn+Backspace to delete the entire line
# bindkey '^[3~' kill-whole-line
# # use fn+Delete to delete the entire line from cursor to end
# bindkey '^[[4~' kill-line
