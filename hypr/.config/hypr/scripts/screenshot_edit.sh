#!/bin/bash

FILE="$1"

if [ -z "$FILE" ]; then
    notify-send "Screenshot" "No file captured"
    exit 1
fi

satty --filename "$FILE"
