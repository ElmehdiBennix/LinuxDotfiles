#!/bin/bash

TEXT=$(hyprshot -m region --raw | tesseract - - -l eng --psm 6 2>/dev/null)

if [ -n "$TEXT" ]; then
    echo "$TEXT" | wl-copy
    notify-send "OCR Successful" "Text copied to clipboard." -i edit-paste
fi
