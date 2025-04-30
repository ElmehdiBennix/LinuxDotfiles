#!/bin/bash

# This pywal script is used to set the color scheme for the terminal and other applications.

check-deps() {
    # Check if the script has one argument
    if ! command -v wal &> /dev/null; then
        echo "pywal could not be found. Please install it first."
        return 1
    elif ! command -v waybar &> /dev/null; then
        echo "waybar could not be found. Please install it first."
        return 1
    elif ! command -v swaync &> /dev/null; then
        echo "swaync could not be found. Please install it first."
        return 1
    elif [ "$#" -ne 1 ]; then
        echo "Usage: $0 <wallpaper>"
        return 1
    elif [ ! -f "$1" ]; then
        echo "Wallpaper file not found: $1"
        return 1
    fi
}

change-color-theme() {
    if ! wal -i "$1"; then
        echo "Failed to generate color scheme with pywal."
        return 1
    fi

    return 0
}

reset-shell() {
    killall waybar && waybar &
    swaync-client -rs
    hyprctl reload
}

main() {
    check-deps "$1"
    if [ $? -eq 0 ]; then
        change-color-theme "$1"
        if [ $? -eq 0 ]; then
            reset-shell
            echo "Theme applied successfully."
            wal --preview
            return 0
        fi
    fi
    return 1
}

main "$1"
