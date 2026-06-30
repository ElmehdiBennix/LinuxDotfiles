#!/bin/zsh
#
# .zshenv - Zsh environment file, loaded always.
#

# NOTE: .zshenv needs to live at ~/.zshenv, not in $ZDOTDIR!

# Set ZDOTDIR if you want to re-home Zsh.
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

# Force ZDOTDIR to our custom location
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Set the list of directories that zsh searches for commands.
path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /usr/local/{,s}bin(N)
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $path
)

# UFW Management Aliases
alias firewall="sudo ufw status numbered"
alias block="sudo ufw deny"  # Usage: block from 192.168.1.5
alias allow="sudo ufw allow" # Usage: allow 22/tcp
alias openports="sudo lsof -i -P -n | grep LISTEN" # See what ports are open locally
