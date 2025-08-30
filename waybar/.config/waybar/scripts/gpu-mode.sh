
#!/bin/bash

# This script checks the active GPU mode using envycontrol and outputs JSON for Waybar.
# It also accepts an argument ('nvidia', 'integrated', 'hybrid') to switch the GPU mode.

# Full path for reliability
ENVYCONTROL="/usr/bin/envycontrol"
SUDO="/usr/bin/sudo"

# Check if envycontrol exists
if ! command -v $ENVYCONTROL &> /dev/null; then
    echo '{"text": "", "class": "error", "tooltip": "envycontrol not found"}'
    exit 1
fi

# --- Argument Handling for Switching Modes ---
# If an argument is passed to the script, treat it as a command to switch modes.
if [ "$#" -gt 0 ]; then
    MODE_TO_SET="$1"

    case $MODE_TO_SET in
        nvidia|integrated|hybrid)
            # Execute the switch command with sudo
            # You may be prompted for your password in the terminal.
            $SUDO $ENVYCONTROL --switch "$MODE_TO_SET"
            # Exit with code 0 to indicate the command was attempted.
            exit 0
            ;;
        *)
            # Handle invalid arguments
            echo "Invalid argument: '$MODE_TO_SET'. Use 'nvidia', 'integrated', or 'hybrid'." >&2
            exit 1
            ;;
    esac
fi

# Get the current modeD
MODE=$($ENVYCONTROL -q)

ICON=""
TOOLTIP=""

case $MODE in
    nvidia)
        ICON="󰢮" # Nerd Font: mdi-nvidia
        TOOLTIP="GPU Mode: NVIDIA"
        ;;
    integrated)
        ICON="" # Nerd Font: fa-leaf
        TOOLTIP="GPU Mode: Integrated"
        ;;
    hybrid)
        ICON="" # Nerd Font: fa-balance-scale
        TOOLTIP="GPU Mode: Hybrid"
        ;;
esac

# Output a single line of JSON with the icon, class, and tooltip
echo "{\"text\": \"$ICON\", \"class\": \"$MODE\", \"tooltip\": \"$TOOLTIP\"}"



# {
#   "icon1": "",
#   "icon2": "",
#   "icon3": "",
#   "icon4": "",
#   "icon6": "",
#   "icon7": "",
#   "icon8": "⚙",
#   "icon10": "",
#   "icon13": "",
#   "icon14": "",
# }
