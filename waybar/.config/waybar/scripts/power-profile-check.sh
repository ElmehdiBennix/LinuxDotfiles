#!/bin/bash

# First, check for the standard power-profiles-daemon
if systemctl is-active --quiet power-profiles-daemon.service; then
    PROFILE=$(powerprofilesctl get)

    # Output JSON using the PPD profile name for the class
    printf '{"text": "%s", "class": "%s", "tooltip": "PPD: %s"}\n' "$PROFILE" "$PROFILE" "$PROFILE"

# If PPD isn't running, check for auto-cpufreq
elif systemctl is-active --quiet auto-cpufreq.service; then
    # **THE FIX IS HERE**
    # Instead of calling auto-cpufreq, we read the governor directly from the /sys filesystem.
    # This is instantaneous and does not require root privileges.
    GOVERNOR_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

    if [ -f "$GOVERNOR_FILE" ]; then
        PROFILE_RAW=$(cat "$GOVERNOR_FILE")

        # Map "powersave" to your existing "power-saver" class for CSS
        CSS_CLASS=$PROFILE_RAW
        if [ "$PROFILE_RAW" == "powersave" ]; then
            CSS_CLASS="power-saver"
        fi

        # Output JSON using the mapped class name
        printf '{"text": "%s", "class": "%s", "tooltip": "auto-cpufreq: %s"}\n' "$PROFILE_RAW" "$CSS_CLASS" "$PROFILE_RAW"
    else
        # Fallback error if the governor file can't be read
        printf '{"text": " Gov ERR", "class": "error", "tooltip": "Cannot read CPU governor state."}\n'
    fi

# If neither service is running, show an error
else
    printf '{"text": " No Power SVC", "class": "error", "tooltip": "Neither PPD nor auto-cpufreq is active."}\n'
fi
