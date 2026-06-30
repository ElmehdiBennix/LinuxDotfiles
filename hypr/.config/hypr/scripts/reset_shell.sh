#!/bin/sh

uwsm app -- vicinae server --restart &

hyprctl reload

exit 0
