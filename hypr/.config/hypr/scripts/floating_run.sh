#!/bin/bash

# Script to open a floating terminal and run an application
# Usage: floating-run.sh <width> <height> <application_name>
# Usage: floating-run.sh <application_name> (uses default 800x450)

if [ $# -eq 0 ]; then
    echo "Usage: $0 <width> <height> <application_name>"
    echo "   or: $0 <application_name> (uses default 800x450)"
    echo "Examples:"
    echo "  $0 1000 600 htop"
    echo "  $0 htop"
    exit 1
fi

# Check if we have 3 parameters (width, height, app) or 1 parameter (just app)
if [ $# -eq 3 ]; then
    WIDTH="$1"
    HEIGHT="$2"
    APP_NAME="$3"
elif [ $# -eq 1 ]; then
    WIDTH="800"
    HEIGHT="450"
    APP_NAME="$1"
else
    echo "Error: Invalid number of parameters"
    echo "Usage: $0 <width> <height> <application_name>"
    echo "   or: $0 <application_name>"
    exit 1
fi

TERMINAL_CMD="$TERMINAL"

if [ -z "$TERMINAL_CMD" ]; then
    ATTRIBUTES_FILE="$HOME/.config/hypr/0_session/attributes.conf"
    if [ -f "$ATTRIBUTES_FILE" ]; then
        TERMINAL_CMD=$(grep "\$terminal =" "$ATTRIBUTES_FILE" | cut -d'=' -f2 | tr -d ' ' | tr -d '"')
    fi
fi

if [ -z "$TERMINAL_CMD" ]; then
    TERMINAL_CMD="ghostty"
fi

hyprctl dispatch exec "[float; size $WIDTH $HEIGHT; center] uwsm app -- $TERMINAL_CMD -e $APP_NAME"
