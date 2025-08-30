#!/bin/bash

# This script uses rofi to present a menu for switching the GPU mode.

# --- CONFIGURATION ---
# IMPORTANT: Set this to the full path of the script that handles the actual switching.
GPU_SWITCH_SCRIPT="./gpu-mode.sh"
# --- END CONFIGURATION ---


# # Check if the switch script exists and is executable
# if [ ! -x "$GPU_SWITCH_SCRIPT" ]; then
#     rofi -e "Error: Switch script not found or not executable at '$GPU_SWITCH_SCRIPT'"
#     exit 1
# fi

# Rofi menu options
# Icons require a Nerd Font to be configured in your rofi theme.
OPTIONS=" Intel (Integrated)\n󰢮 NVIDIA (Performance)\n Hybrid (Balanced)"

# Show the rofi menu and capture the user's choice.
# -dmenu: Run in dmenu mode (reads from stdin).
# -p: Sets the prompt text.
# -i: Makes matching case-insensitive.
CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Select GPU Mode")

# Execute the appropriate command based on the user's choice.
case "$CHOSEN" in
    " Intel (Integrated)")
        "$GPU_SWITCH_SCRIPT" integrated
        ;;
    "󰢮 NVIDIA (Performance)")
        "$GPU_SWITCH_SCRIPT" nvidia
        ;;
    " Hybrid (Balanced)")
        "$GPU_SWITCH_SCRIPT" hybrid
        ;;
esac

# Note: If you press Esc in rofi, $CHOSEN will be empty, and the script will simply exit.
