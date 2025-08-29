#!/bin/bash

# This script checks the active GPU mode using envycontrol and outputs JSON for Waybar.

# Full path for reliability
ENVYCONTROL="/usr/bin/envycontrol"

# Check if envycontrol exists
if ! command -v $ENVYCONTROL &> /dev/null; then
    echo '{"text": "󰢲", "class": "error", "tooltip": "envycontrol not found"}'
    exit 1
fi

# Get the current mode
MODE=$($ENVYCONTROL -q)

ICON=""
TOOLTIP=""

case $MODE in
    nvidia)
        ICON="󰟫" # NVIDIA logo
        TOOLTIP="GPU Mode: NVIDIA"
        ;;
    integrated)
        ICON="󰾢" # Generic chip/integrated icon
        TOOLTIP="GPU Mode: Integrated"
        ;;
    hybrid)
        ICON="󰢮" # Layers/hybrid icon
        TOOLTIP="GPU Mode: Hybrid"
        ;;
    *)
        ICON="" # Question mark for unknown state
        TOOLTIP="GPU Mode: Unknown"
        MODE="error" # Use 'error' class for styling
        ;;
esac

# Output a single line of JSON with the icon, class, and tooltip
echo "{\"text\": \"$ICON\", \"class\": \"$MODE\", \"tooltip\": \"$TOOLTIP\"}"
