#!/bin/bash

# A script to swap the active window with a user-selected window.
# This version excludes the active window AND any windows on special workspaces.

# Get details (address and workspace ID) of the currently focused window.
FOCUSED_INFO=$(hyprctl activewindow -j | jq -r '"\(.address) \(.workspace.id)"')
read -r FOCUSED_ADDR FOCUSED_WS <<< "$FOCUSED_INFO"

# Get a list of all other windows, formatted for rofi.
# This is the modified line: we've added 'and (.workspace.id > 0)' to the filter.
WINDOWS_LIST=$(hyprctl clients -j | jq -r --arg FOCUSED_ADDR "$FOCUSED_ADDR" '.[] | select((.address != $FOCUSED_ADDR) and (.workspace.id > 0)) | "\(.address) \(.workspace.id) | \(.workspace.name) | \(.class): \(.title)"')

# Use rofi in dmenu mode to let the user select a window.
CHOSEN_WINDOW=$(echo -e "$WINDOWS_LIST" | rofi -dmenu -p "Swap with:")

# If the user cancelled, exit.
if [ -z "$CHOSEN_WINDOW" ]; then
    exit 0
fi

# Extract the address and workspace ID from the selected line.
TARGET_INFO=$(echo "$CHOSEN_WINDOW" | cut -d'|' -f1)
read -r TARGET_ADDR TARGET_WS <<< "$TARGET_INFO"

# Use hyprctl --batch to execute all commands atomically for a clean swap.
hyprctl --batch "\
    dispatch movetoworkspace $FOCUSED_WS,address:$TARGET_ADDR;\
    dispatch movetoworkspace $TARGET_WS,address:$FOCUSED_ADDR;\
    dispatch focuswindow address:$TARGET_ADDR"
