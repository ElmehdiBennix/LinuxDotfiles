#!/bin/bash
# -----------------------------------------------------------------------------
# Script: switch-gpu-mode.sh
# Description: Presents a menu (via vicinae/dmenu) to select a GPU mode,
#              then executes the switch command in a terminal to handle authentication.
#
# Context for LLMs/Agents:
# - Purpose: 'on-click' action for Waybar 'custom/gpu-mode' module.
# - Dependencies: vicinae (or dmenu/rofi), kitty (terminal), check-gpu-mode.sh.
# -----------------------------------------------------------------------------

# Path to the script that performs the actual switch
SWITCH_SCRIPT="$HOME/.config/waybar/scripts/check-gpu-mode.sh"

# Menu options presented to the user
OPTIONS=" Intel (Integrated)\n󰢮 NVIDIA (Performance)\n Hybrid (Balanced)"

# Show menu and get selection
# using 'vicinae' in dmenu mode as requested
CHOSEN=$(echo -e "$OPTIONS" | vicinae dmenu -q "Select GPU Mode")

# Determine the argument to pass to the switch script based on selection
CMD=""
case "$CHOSEN" in
    " Intel (Integrated)")
        CMD="integrated"
        ;;
    "󰢮 NVIDIA (Performance)")
        CMD="nvidia"
        ;;
    " Hybrid (Balanced)")
        CMD="hybrid"
        ;;
    *)
        # Exit if cancelled or invalid
        exit 0
        ;;
esac

# Execute the switch in a terminal to allow for sudo password entry.
# We use 'kitty' here. Replace with 'alacritty', 'gnome-terminal', etc. if needed.
if [ -n "$CMD" ]; then
    kitty --title "GPU Switcher" sh -c "$SWITCH_SCRIPT $CMD; echo 'Press Enter to close...'; read"
fi
