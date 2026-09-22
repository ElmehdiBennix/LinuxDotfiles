#!/usr/bin/env bash

sleep 1

ghostty --class=com.ghostty.scratch -e tmux new-session -A -s SYSTEM &

sleep 1

niri msg action focus-workspace 2

zen-browser &