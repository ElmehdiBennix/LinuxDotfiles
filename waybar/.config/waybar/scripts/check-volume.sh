#!/bin/bash
# -----------------------------------------------------------------------------
# Script: check-volume.sh
# Description: Unified script to check volume/mute status for Sinks (Speakers) 
#              and Sources (Microphones) using wpctl (PipeWire).
# Usage: ./check-volume.sh [sink|source]
# -----------------------------------------------------------------------------

MODE="$1" # 'sink' or 'source'

# Verify input
if [[ "$MODE" != "sink" && "$MODE" != "source" ]]; then
    ERR="Usage: $0 [sink|source]"
    echo "Error: $ERR" >&2
    printf '{"text": "ERR", "class": "error", "tooltip": "%s"}\n' "$ERR"
    exit 1
fi

# Set target and icons
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

# Check dependencies (Critical)
for cmd in wpctl bc awk; do
    if ! command -v "$cmd" &> /dev/null; then
        ERR="Missing dependency: $cmd"
        echo "Error: $ERR" >&2
        printf '{"text": "ERR", "class": "error", "tooltip": "%s"}\n' "$ERR"
        exit 1
    fi
done

# Get status
STATUS_OUTPUT=$(wpctl get-volume "$TARGET" 2>/dev/null)

# Check if command failed
if [ -z "$STATUS_OUTPUT" ]; then
    ERR="wpctl failed or returned empty for $TARGET"
    echo "Error: $ERR" >&2
    printf '{"text": "ERR", "class": "error", "tooltip": "%s"}\n' "$ERR"
    exit 0
fi

# --- Logic ---

if echo "$STATUS_OUTPUT" | grep -q "MUTED"; then
    printf '{"text": "%s", "class": "%s", "tooltip": "Muted"}\n' "$ICON_MUTED" "$CLASS_MUTED"
else
    # Parse volume
    VOLUME_FLOAT=$(echo "$STATUS_OUTPUT" | awk '{print $2}')
    VOLUME_PERCENT=$(echo "$VOLUME_FLOAT * 100" | bc | cut -d. -f1)

    # Determine Icon
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
