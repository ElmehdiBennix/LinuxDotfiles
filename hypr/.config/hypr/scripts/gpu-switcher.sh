#!/bin/bash
# Hyprland GPU Switcher - Switch between supergfxctl modes with Hyprland config update

set -e

show_help() {
    cat << EOF
Hyprland GPU Switcher

Usage: $0 [MODE]

Modes:
  integrated    Switch to Intel iGPU only (power saving)
  hybrid        Switch to NVIDIA dGPU + Intel (performance)
  status        Show current mode and configuration
  reload        Reload Hyprland config (after mode change)

Examples:
  $0 integrated    # Switch to integrated graphics
  $0 hybrid        # Switch to hybrid graphics
  $0 status        # Check current mode

Note: Mode changes require logout/login to take effect in Hyprland.
EOF
}

get_current_mode() {
    supergfxctl -g 2>/dev/null || echo "unknown"
}

show_status() {
    current_mode=$(get_current_mode)
    echo "Current supergfxctl mode: $current_mode"
    echo ""
    echo "Active GPU configuration:"
    
    if [ "$current_mode" = "Hybrid" ]; then
        echo "  - AQ_DRM_DEVICES: /dev/dri/card2:/dev/dri/card1 (NVIDIA:Intel)"
        echo "  - GBM_BACKEND: nvidia-drm"
        echo "  - LIBVA_DRIVER_NAME: nvidia"
        echo "  - __NV_PRIME_RENDER_OFFLOAD: 1"
        echo ""
        echo "Apps will render on NVIDIA GPU (high performance)"
    elif [ "$current_mode" = "Integrated" ]; then
        echo "  - AQ_DRM_DEVICES: /dev/dri/card1 (Intel only)"
        echo "  - GBM_BACKEND: (unset - using default)"
        echo "  - LIBVA_DRIVER_NAME: iHD"
        echo "  - __NV_PRIME_RENDER_OFFLOAD: (unset)"
        echo ""
        echo "Apps will render on Intel iGPU (power saving)"
    fi
}

switch_mode() {
    new_mode=$1
    current_mode=$(get_current_mode)
    
    if [ "$new_mode" = "$current_mode" ]; then
        echo "Already in $current_mode mode"
        show_status
        return
    fi
    
    echo "Switching from $current_mode to $new_mode mode..."
    supergfxctl -m "$new_mode"
    
    echo ""
    echo "Mode switched successfully!"
    echo ""
    echo "IMPORTANT: You must log out and log back in for Hyprland to use the new GPU configuration."
    echo ""
    read -p "Would you like to log out now? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        loginctl terminate-user "$USER"
    fi
}

case "${1:-}" in
    integrated)
        switch_mode "Integrated"
        ;;
    hybrid)
        switch_mode "Hybrid"
        ;;
    status)
        show_status
        ;;
    reload)
        echo "Reloading Hyprland config..."
        hyprctl reload
        echo "Config reloaded. Note: GPU mode changes still require logout/login."
        ;;
    -h|--help|help)
        show_help
        ;;
    *)
        echo "Error: Unknown mode '$1'"
        echo ""
        show_help
        exit 1
        ;;
esac
