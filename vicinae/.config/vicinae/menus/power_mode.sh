#!/bin/bash

## add option for hypridle inhibite will show one more option for inhib false if clicked it turn to true and always shows current state in the menu option when clicked it changes it

OPTIONS="󰓅 Performance\n󰾅 Balanced\n󰾆 Power Saver"

CHOSEN=$(echo -e "$OPTIONS" | vicinae dmenu -p "Select Power Profile")

case "$CHOSEN" in
    "󰓅 Performance")
        powerprofilesctl set performance
        ;;
    "󰾅 Balanced")
        powerprofilesctl set balanced
        ;;
    "󰾆 Power Saver")
        powerprofilesctl set power-saver
        ;;
esac
