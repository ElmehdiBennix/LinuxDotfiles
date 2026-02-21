#!/bin/sh

killall -q waybar swaync

uwsm app -- waybar &
uwsm app -- swaync &
uwsm app -- vicinae server --restart &

hyprctl reload

exit 0
