# [[ -v terminfo ]] || zmodload zsh/terminfo

# if [[ -n "$terminfo[kcuu1]" ]]; then
#   bindkey -M emacs "$terminfo[kcuu1]" history-substring-search-up
#   bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up
# fi
# if [[ -n "$terminfo[kcud1]" ]]; then
#   bindkey -M emacs "$terminfo[kcud1]" history-substring-search-down
#   bindkey -M viins "$terminfo[kcud1]" history-substring-search-down
# fi

















# Load TTY colors
if [[ -f "$HOME/.cache/matugen/tty_colors" ]]; then
  source "$HOME/.cache/matugen/tty_colors"

  # Apply ANSI escape sequences for 16-color TTY
  print -Pn "\e]4;0;${COLOR_0}\a"
  print -Pn "\e]4;1;${COLOR_1}\a"
  print -Pn "\e]4;2;${COLOR_2}\a"
  print -Pn "\e]4;3;${COLOR_3}\a"
  print -Pn "\e]4;4;${COLOR_4}\a"
  print -Pn "\e]4;5;${COLOR_5}\a"
  print -Pn "\e]4;6;${COLOR_6}\a"
  print -Pn "\e]4;7;${COLOR_7}\a"

  print -Pn "\e]4;8;${COLOR_8}\a"
  print -Pn "\e]4;9;${COLOR_9}\a"
  print -Pn "\e]4;10;${COLOR_10}\a"
  print -Pn "\e]4;11;${COLOR_11}\a"
  print -Pn "\e]4;12;${COLOR_12}\a"
  print -Pn "\e]4;13;${COLOR_13}\a"
  print -Pn "\e]4;14;${COLOR_14}\a"
  print -Pn "\e]4;15;${COLOR_15}\a"
fi

#########################
# key bindings
#########################

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
