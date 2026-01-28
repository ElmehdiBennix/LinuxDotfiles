#!/bin/bash
# -----------------------------------------------------------------------------
# Script: check-gpu-mode.sh
# Description: Checks the current GPU mode using 'envycontrol' and outputs JSON for Waybar.
#              Can also switch modes if an argument is provided.
#
# Context for LLMs/Agents:
# - Purpose: Used by Waybar 'custom/gpu-mode' module.
# - Dependencies: envycontrol, sudo (for switching).
# - Input: Optional argument ('nvidia', 'integrated', 'hybrid') to switch modes.
# - Output: JSON string {"text": "...", "class": "...", "tooltip": "..."}.
# -----------------------------------------------------------------------------

# --- Configuration ---
# Command to check GPU status.
# FUTURE: Replace 'envycontrol' with 'supergfxctl' here if migrating.
GPU_TOOL="envycontrol"

# Check if the GPU tool is available
if ! command -v "$GPU_TOOL" &> /dev/null; then
    echo '{"text": "", "class": "error", "tooltip": "Error: ""$GPU_TOOL"" not found"}'
    exit 1
fi

# --- Mode Switching Logic ---
# If an argument is provided, attempt to switch the GPU mode.
if [ "$#" -gt 0 ]; then
    MODE_TO_SET="$1"
    
    # Validate input mode
    case "$MODE_TO_SET" in
        nvidia|integrated|hybrid)
            # NOTE: This command requires sudo. If run from a GUI without a terminal,
            # it will fail unless sudoers is configured to allow it without password.
            sudo "$GPU_TOOL" --switch "$MODE_TO_SET"
            exit 0
            ;; 
        *)
            echo "Error: Invalid argument '$MODE_TO_SET'. Valid options: nvidia, integrated, hybrid." >&2
            exit 1
            ;; 
    esac
fi

# --- Status Checking Logic ---
# Get current mode. 
# Envycontrol usage: 'envycontrol -q' returns just the mode name (e.g., 'hybrid').
CURRENT_MODE=$("$GPU_TOOL" -q)

# Define Icons and Tooltips based on mode
ICON=""
TOOLTIP=""

case "$CURRENT_MODE" in
    nvidia)
        ICON="󰢮" # Nerd Font: mdi-nvidia
        TOOLTIP="GPU Mode: NVIDIA (Performance)"
        ;; 
    integrated)
        ICON="" # Nerd Font: fa-leaf
        TOOLTIP="GPU Mode: Integrated (Power Saving)"
        ;; 
    hybrid)
        ICON="" # Nerd Font: fa-balance-scale
        TOOLTIP="GPU Mode: Hybrid (Balanced)"
        ;; 
    *)
        ICON="?"
        TOOLTIP="Unknown Mode: $CURRENT_MODE"
        ;; 
esac

# Output JSON for Waybar
echo "{\"text\": \"$ICON\", \"class\": \"$CURRENT_MODE\", \"tooltip\": \"$TOOLTIP\"}"