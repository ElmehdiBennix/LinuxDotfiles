#!/bin/bash

active_addr=$(hyprctl -j activewindow | jq -r '.address')

other_windows=$(hyprctl clients -j | jq -r --arg active_addr "$active_addr" \
  '.[] | select(.address != $active_addr and .workspace.id > 0) | "\(.address) \(.class): \(.title)"')

if [ -z "$other_windows" ]; then
    exit 0
fi

selected=$(echo "$other_windows" | cut -d' ' -f2- | vicinae dmenu -p "Swap with")

if [ -n "$selected" ]; then
    target_addr=$(echo "$other_windows" | grep -F "$selected" | head -n 1 | awk '{print $1}')

    if [ -n "$target_addr" ]; then
        hyprctl dispatch swapwindow address:$target_addr
        hyprctl dispatch focuswindow address:$target_addr
    fi
fi
