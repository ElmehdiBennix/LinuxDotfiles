#!/bin/sh

killall -q waybar
waybar &

killall -q swaync
swaync &

killall -q  vicinae
vicinae server &

hyprctl dispatch vdeskreset
hyprctl reload


exit 0
