#!/bin/bash

MODE="$1"

if [[ "$MODE" != "sink" && "$MODE" != "source" ]]; then
    exit 1
fi

if [[ "$MODE" == "sink" ]]; then
    TARGET="@DEFAULT_SINK@"
    ICON_MUTED="󰸈"
    ICON_LOW=""
    ICON_MED=""
    ICON_HIGH=""
    CLASS_MUTED="muted"
else
    TARGET="@DEFAULT_SOURCE@"
    ICON_MUTED="󰍭"
    ICON_LOW="󰍫"
    ICON_MED="󰍫" 
    ICON_HIGH="󰍬"
    CLASS_MUTED="source-muted"
fi

STATUS_OUTPUT=$(wpctl get-volume "$TARGET" 2>/dev/null)

if [ -z "$STATUS_OUTPUT" ]; then
    printf '{"text": "ERR", "class": "error"}\n'
    exit 0
fi

if echo "$STATUS_OUTPUT" | grep -q "MUTED"; then
    printf '{"text": "%s", "class": "%s", "tooltip": "Muted"}\n' "$ICON_MUTED" "$CLASS_MUTED"
else
    VOLUME_PERCENT=$(echo "$STATUS_OUTPUT" | awk '{printf "%d", $2 * 100}')

    if [ "$VOLUME_PERCENT" -eq 0 ]; then
        ICON="$ICON_MUTED"
    elif [ "$VOLUME_PERCENT" -lt 30 ]; then
        ICON="$ICON_LOW"
    elif [ "$VOLUME_PERCENT" -lt 70 ]; then
        ICON="$ICON_MED"
    else
        ICON="$ICON_HIGH"
    fi

    printf '{"text": "%s", "class": "active", "tooltip": "Volume: %s%%"}\n' "$ICON" "$VOLUME_PERCENT"
fi
