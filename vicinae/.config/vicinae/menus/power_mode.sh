#!/bin/bash

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
