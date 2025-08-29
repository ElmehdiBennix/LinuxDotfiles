#!/bin/bash

# --- Find Battery ---
BATTERY_PATH=$(find /sys/class/power_supply/BAT* -print -quit)
if [ -z "$BATTERY_PATH" ]; then
    exit 1 # Exit if no battery is found
fi

# --- Get Info ---
CAPACITY=$(cat "$BATTERY_PATH/capacity")
STATUS=$(cat "$BATTERY_PATH/status")
PROFILE=$(powerprofilesctl get)

# --- Define Icons and Thresholds (from your config) ---
ICON_CHARGING=""
ICON_PLUGGED=""
ICON_PLUGORDIE="󰯈"
ICONS_DISCHARGING=("" "" "" "" "")

THRESHOLD_PLUGORDIE=15

# --- Logic for Battery Icon ---
ICON=""
if [ "$STATUS" = "Charging" ]; then
    ICON="$ICON_CHARGING"
elif [ "$STATUS" != "Discharging" ]; then # Handles "Full" or "Not charging"
    ICON="$ICON_PLUGGED"
else # Discharging
    if [ "$CAPACITY" -le "$THRESHOLD_PLUGORDIE" ]; then
        ICON="$ICON_PLUGORDIE"
    elif [ "$CAPACITY" -le 20 ]; then
        ICON="${ICONS_DISCHARGING[0]}"
    elif [ "$CAPACITY" -le 40 ]; then
        ICON="${ICONS_DISCHARGING[1]}"
    elif [ "$CAPACITY" -le 60 ]; then
        ICON="${ICONS_DISCHARGING[2]}"
    elif [ "$CAPACITY" -le 80 ]; then
        ICON="${ICONS_DISCHARGING[3]}"
    else
        ICON="${ICONS_DISCHARGING[4]}"
    fi
fi

# --- Construct JSON Output for Waybar ---
# "text" shows the battery icon and the power profile name
# "tooltip" shows the battery charge percentage
printf '{"text": "%s %s", "tooltip": "Charge: %s%%"}\n' "$ICON" "$PROFILE" "$CAPACITY"
