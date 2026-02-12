#!/bin/bash

# 1. Clean up any existing headless monitors
hyprctl monitors -j | jq -r '.[] | select(.name | startswith("HEADLESS")) | .name' | xargs -I {} hyprctl output remove {}

# 2. If the script was called with "stop", we just exit here
if [ "$1" == "stop" ]; then
    exit 0
fi

# 3. Create new headless monitor
hyprctl output create headless
sleep 1 # Wait for Hyprland to register it

# 4. Find the name of the new monitor (e.g., HEADLESS-2)
NAME=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("HEADLESS")) | .name' | tail -n 1)

# 5. Configure the resolution (4K @ 60Hz)
hyprctl keyword monitor "$NAME, 3840x2160@60, auto, 1"

# 6. Optional: Move workspace 10 to this monitor and focus it
# This helps Sunshine "find" the right screen
hyprctl keyword workspace 10, monitor:"$NAME"
hyprctl dispatch workspace 10
