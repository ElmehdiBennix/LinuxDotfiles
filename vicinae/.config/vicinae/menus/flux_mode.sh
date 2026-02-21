#!/bin/bash

OPTIONS="󰖨 Off\n󰖔 Evening (4500K)\n󱩌 Night (3000K)\n󱩍 Late Night (2000K)"

CHOSEN=$(echo -e "$OPTIONS" | vicinae dmenu -p "Select Flux Intensity")

pkill hyprsunset

case "$CHOSEN" in
    "󰖔 Evening (4500K)")
        hyprsunset -t 4500 &
        ;;
    "󱩌 Night (3000K)")
        hyprsunset -t 3000 &
        ;;
    "󱩍 Late Night (2000K)")
        hyprsunset -t 2000 &
        ;;
esac
