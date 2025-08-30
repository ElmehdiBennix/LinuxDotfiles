#!/bin/sh

killall -q waybar
killall -q swaync

waybar &
swaync &

exit 0
