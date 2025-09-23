#!/bin/bash

# Get the active window's information first
active_window_info=$(hyprctl -j activewindow)
active_window_address=$(echo "$active_window_info" | jq -r '.address')
# MODIFIED: Removed the address from the display line
active_window_line=$(echo "$active_window_info" | jq -r '"\(.class): \(.title)"')

# Get a list of all other windows, excluding the active one.
# We still need the address for switching, but we won't display it.
other_windows=$(hyprctl clients -j | jq -r --arg active_addr "$active_window_address" \
  '.[] | select(.address != $active_addr and .workspace.id > 0) | "\(.address)    \(.class) ~ \(.title)"')

# If there are no other windows to switch to, exit
if [ -z "$other_windows" ]; then
    exit 0
fi

# MODIFIED: Use a different variable for Rofi that doesn't include the address
rofi_list=$(echo -e "$active_window_line\n$(echo "$other_windows" | sed 's/^\S*\s*//')")

# Let the user select a window using rofi
# MODIFIED: Pass the new list to rofi
selected_window_display=$(echo -e "$rofi_list" | rofi -dmenu -i -p "Switch to" \
                                            -theme "~/.config/rofi/menus/swap_picker.rasi" \
                                             -kb-row-down "ALT+Tab" \
                                             -kb-accept-entry "!Alt_L" \
                                             -kb-cancel "ALT+Escape")

# If the user made a selection (didn't press Escape)
if [ -n "$selected_window_display" ]; then
    # Find the full line (including address) corresponding to the selection
    selected_window=$(echo -e "$active_window_line\n$other_windows" | grep -F "$selected_window_display" | head -n 1)

    # Extract the window address from the selected line
    window_address=$(echo "$selected_window" | awk '{print $1}')

    # Only dispatch if a different window was selected
    if [ "$window_address" != "$active_window_address" ]; then
        hyprctl dispatch swapwindow address:$window_address
        hyprctl dispatch focuswindow address:$window_address
        hyprctl reload
    fi
fi
