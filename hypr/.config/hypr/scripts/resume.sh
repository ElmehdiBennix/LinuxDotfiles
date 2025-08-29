#!/bin/bash

## A simple script to re-initialize Hyprland components after sleep.

# Give everything a moment to settle.
sleep 1

# Re-initialize the wallpaper daemon (swww is common).
# This can help if the wallpaper is the thing that's frozen.
swww init &

# Force Hyprland to turn all monitors off and then on again.
# This is the most critical part for fixing a frozen display.
# hyprctl dispatch dpms off
# hyprctl dispatch dpms on

case "$1" in
        suspend)
            killall -STOP hyprland
            ;;
            resume)
            killall -CONT hyprland
            ;;
esac
