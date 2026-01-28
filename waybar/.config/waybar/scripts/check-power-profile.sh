#!/bin/bash
# -----------------------------------------------------------------------------
# Script: check-power-profile.sh
# Description: Detects the active power profile using 'power-profiles-daemon' (PPD)
#              or 'auto-cpufreq' and outputs JSON for Waybar.
#
# Context for LLMs/Agents:
# - Purpose: Used by Waybar 'custom/power-profile' module.
# - Dependencies: powerprofilesctl OR /sys/devices/... (for auto-cpufreq fallback).
# - Output: JSON string {"text": "...", "class": "...", "tooltip": "..."}.
# -----------------------------------------------------------------------------

# --- PPD Check ---
if command -v systemctl &> /dev/null && systemctl is-active --quiet power-profiles-daemon.service; then
    if command -v powerprofilesctl &> /dev/null; then
        PROFILE=$(powerprofilesctl get)
        # JSON Output
        printf '{"text": "%s", "class": "%s", "tooltip": "PPD: %s"}\n' "$PROFILE" "$PROFILE" "$PROFILE"
        exit 0
    fi
fi

# --- auto-cpufreq Check ---
if command -v systemctl &> /dev/null && systemctl is-active --quiet auto-cpufreq.service; then
    # Direct file read is faster/safer than spawning a process
    GOVERNOR_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

    if [ -f "$GOVERNOR_FILE" ]; then
        PROFILE_RAW=$(cat "$GOVERNOR_FILE")
        
        # Map raw governor names to CSS classes matching PPD naming convention for consistency
        # powersave -> power-saver
        CSS_CLASS=$PROFILE_RAW
        if [ "$PROFILE_RAW" == "powersave" ]; then
            CSS_CLASS="power-saver"
        fi

        printf '{"text": "%s", "class": "%s", "tooltip": "auto-cpufreq: %s"}\n' "$PROFILE_RAW" "$CSS_CLASS" "$PROFILE_RAW"
        exit 0
    else
        printf '{"text": " Gov ERR", "class": "error", "tooltip": "Error: Cannot read CPU governor."}\n'
        exit 1
    fi
fi

# --- Fallback/Error ---
printf '{"text": " No Power SVC", "class": "error", "tooltip": "Error: Neither PPD nor auto-cpufreq active."}\n'