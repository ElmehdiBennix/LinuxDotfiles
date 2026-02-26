#!/bin/bash

if pgrep -x hyprsunset > /dev/null; then
    pkill hyprsunset
    notify-send "Flux" "Turned off"
else
    OPTIONS="󰆌 Day (6500K)
󰖔 Evening (4500K)
󱩌 Night (3000K)
󱩍 Late Night (2000K)
󱪆 Deep Night (1500K)
󱤆 Darkest (1000K)"

    CHOSEN=$(echo -e "$OPTIONS" | vicinae dmenu -p "Select Flux Intensity")

    case "$CHOSEN" in
        "󰆌 Day (6500K)")
            sleep 0.3
            hyprsunset -t 6500
            ;;
        "󰖔 Evening (4500K)")
            sleep 0.3
            hyprsunset -t 4500
            ;;
        "󱩌 Night (3000K)")
            sleep 0.3
            hyprsunset -t 3000
            ;;
        "󱩍 Late Night (2000K)")
            sleep 0.3
            hyprsunset -t 2000
            ;;
        "󱪆 Deep Night (1500K)")
            sleep 0.3
            hyprsunset -t 1500
            ;;
        "󱤆 Darkest (1000K)")
            sleep 0.3
            hyprsunset -t 1000
            ;;
    esac
fi
