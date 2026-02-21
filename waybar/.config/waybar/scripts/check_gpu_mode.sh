#!/bin/bash

GPU_TOOL="supergfxctl"

if ! command -v "$GPU_TOOL" &> /dev/null; then
    printf '{"text": "", "class": "error", "tooltip": "Error: %s not found"}\n' "$GPU_TOOL"
    exit 1
fi

if [ "$#" -gt 0 ]; then
    case "$1" in
        Hybrid|Integrated|Nvidia|Vfio)
            "$GPU_TOOL" -m "$1"
            exit 0
            ;; 
        *)
            exit 1
            ;; 
    esac
fi

CURRENT_MODE=$("$GPU_TOOL" -g)

case "$CURRENT_MODE" in
    Nvidia)
        ICON="󰢮"
        TOOLTIP="GPU Mode: NVIDIA"
        ;; 
    Integrated)
        ICON=""
        TOOLTIP="GPU Mode: Integrated"
        ;; 
    Hybrid)
        ICON=""
        TOOLTIP="GPU Mode: Hybrid"
        ;; 
    Vfio)
        ICON="󰡝"
        TOOLTIP="GPU Mode: VFIO (Passthrough)"
        ;;
    *)
        ICON="?"
        TOOLTIP="Unknown Mode: $CURRENT_MODE"
        ;; 
esac

echo "{\"text\": \"$ICON\", \"class\": \"$CURRENT_MODE\", \"tooltip\": \"$TOOLTIP\"}"
