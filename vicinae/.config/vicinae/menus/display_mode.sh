#!/bin/bash

CONFIG_FILE="$HOME/.config/hyprdynamicmonitors/config.toml"

if [ ! -f "$CONFIG_FILE" ]; then
    notify-send "Display Mode" "Configuration file not found."
    exit 1
fi

PROFILES=$(grep "\[profiles\." "$CONFIG_FILE" | sed -E 's/\[profiles\.([^]]+)\]/\1/')

if [ -z "$PROFILES" ]; then
    notify-send "Display Mode" "No profiles found."
    exit 1
fi

CHOSEN=$(echo "$PROFILES" | vicinae dmenu -p "Select Display Profile")

if [ -n "$CHOSEN" ]; then
    TEMPLATE_FILE=$(grep -A 2 "\[profiles\.$CHOSEN\]" "$CONFIG_FILE" | grep "config_file =" | cut -d'"' -f2)
    
    if [ -f "$TEMPLATE_FILE" ]; then
        notify-send "Display Mode" "Switching to $CHOSEN..."
    fi
fi
