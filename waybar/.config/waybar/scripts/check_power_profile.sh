#!/bin/bash

if systemctl is-active --quiet power-profiles-daemon.service; then
    PROFILE=$(powerprofilesctl get)
    printf '{"text": "%s", "class": "%s", "tooltip": "PPD: %s"}\n' "$PROFILE" "$PROFILE" "$PROFILE"
    exit 0
fi

if systemctl is-active --quiet auto-cpufreq.service; then
    GOVERNOR_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

    if [ -f "$GOVERNOR_FILE" ]; then
        PROFILE_RAW=$(cat "$GOVERNOR_FILE")
        CSS_CLASS=$PROFILE_RAW
        [ "$PROFILE_RAW" == "powersave" ] && CSS_CLASS="power-saver"

        printf '{"text": "%s", "class": "%s", "tooltip": "auto-cpufreq: %s"}\n' "$PROFILE_RAW" "$CSS_CLASS" "$PROFILE_RAW"
        exit 0
    fi
fi

printf '{"text": "", "class": "error", "tooltip": "No Power Service"}\n'
