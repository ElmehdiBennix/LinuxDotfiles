#!/bin/bash

# This script implements the specific logic for Muted vs 0% Volume.

# Full paths for reliability
WPCTL="/usr/bin/wpctl"
BC="/usr/bin/bc"

# Get microphone status
STATUS_OUTPUT=$($WPCTL get-volume @DEFAULT_SOURCE@ 2>/dev/null)

if [ -z "$STATUS_OUTPUT" ]; then
    echo '{"text": "󰍭", "class": "error", "tooltip": "Error: Mic status unavailable"}'
    exit 0
fi

# FIRST CHECK: Is the source explicitly MUTED?
if echo "$STATUS_OUTPUT" | grep -q "MUTED"; then
    # If yes, send the muted icon and the special "source-muted" class for red styling.
    echo '{"text": "󰍭", "class": "source-muted", "tooltip": "Microphone is Muted"}'
else
    # If NOT muted, then we proceed to check the volume level.
    # This block handles all "active" states, including 0% volume.
    VOLUME_FLOAT=$(echo "$STATUS_OUTPUT" | awk '{print $2}')
    VOLUME_PERCENT=$(echo "$VOLUME_FLOAT * 100" | $BC | cut -d. -f1)

    if [ "$VOLUME_PERCENT" -eq 0 ]; then
        # Muted icon for 0% volume, but with normal class
        ICON="󰍭"
    elif [ "$VOLUME_PERCENT" -lt 50 ]; then
        ICON="󰍫"  # Low Volume Mic
    else
        ICON="󰍬"  # High Volume Mic
    fi

    # Output the chosen icon with the default "active" class.
    echo "{\"text\": \"$ICON\", \"class\": \"active\", \"tooltip\": \"Mic Volume: $VOLUME_PERCENT%\"}"
fi
