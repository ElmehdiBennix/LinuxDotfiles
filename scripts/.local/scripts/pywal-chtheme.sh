#!/bin/bash

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
    change-color-theme "$1"
    if [ $? -eq 0 ]; then
        reset-shell
        notify-send "Theme applied successfully."
        return 0
    fi
    return 1
}

main "$1"
