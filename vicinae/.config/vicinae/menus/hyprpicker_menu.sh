#!/bin/bash

OPTIONS="HEX #RRGGBB
RGB rgb(r, g, b)
RGBA rgba(r, g, b, a)
HSL hsl(h, s%, l%)
HSV hsv(h, s%, v%)
CMYK cmyk(c%, m%, y%, k%)"

CHOSEN=$(echo -e "$OPTIONS" | vicinae dmenu -p "Color Format")

case "$CHOSEN" in
    "HEX #RRGGBB")
        hyprpicker -a -f hex -n
        ;;
    "RGB rgb(r, g, b)")
        hyprpicker -a -f rgb -o "rgb({0}, {1}, {2})" -n
        ;;
    "RGBA rgba(r, g, b, a)")
        hyprpicker -a -f rgb -o "rgba({0}, {1}, {2}, 1)" -n
        ;;
    "HSL hsl(h, s%, l%)")
        hyprpicker -a -f hsl -o "hsl({0}, {1}%, {2}%)" -n
        ;;
    "HSV hsv(h, s%, v%)")
        hyprpicker -a -f hsv -o "hsv({0}, {1}%, {2}%)" -n
        ;;
    "CMYK cmyk(c%, m%, y%, k%)")
        hyprpicker -a -f cmyk -o "cmyk({0}%, {1}%, {2}%, {3}%)" -n
        ;;
esac
