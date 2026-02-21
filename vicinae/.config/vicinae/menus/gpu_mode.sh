#!/bin/bash


# GPU Mode Switcher for Vicinae Menu
# Uses gpu-switcher.sh for Hyprland integration

# Path to the gpu-switcher script
SWITCH_SCRIPT="$HOME/.config/hypr/scripts/gpu-switcher.sh"

# Menu options presented to the user
OPTIONS=" Integrated (Power Saving)\n Hybrid (NVIDIA dGPU)"

# Show menu and get selection
CHOSEN=$(echo -e "$OPTIONS" | vicinae dmenu -p "Select GPU Mode")

case "$CHOSEN" in
    " Integrated (Power Saving)")
        CMD="integrated"
        ;;
    " Hybrid (NVIDIA dGPU)")
        CMD="hybrid"
        ;;
    *)
        exit 0
        ;;
esac

if [ -n "$CMD" ]; then
    ghostty --title="GPU Switcher" -e sh -c "$SWITCH_SCRIPT $CMD"
fi
