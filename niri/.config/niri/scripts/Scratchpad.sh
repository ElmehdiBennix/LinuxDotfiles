#!/usr/bin/env bash
APP_ID="com.ghostty.scratch"
SPAWN_CMD="ghostty --class=$APP_ID -e tmux new-session -A -s SYSTEM"

WIDTH="80%"
HEIGHT="75%"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/ghostty_scratch_tmux"

# Query window properties (taking the first matching window)
WIN_DATA=$(niri msg --json windows | jq -r --arg app "$APP_ID" '
    [.[] | select(.app_id == $app)] | first |
    if . == null then "" else "\(.id)|\(.is_focused)|\(.is_floating)|\(.pid)" end
')

if [ -z "$WIN_DATA" ]; then
    # Window doesn't exist; launch it attached to SYSTEM
    $SPAWN_CMD &
    exit 0
fi

IFS='|' read -r WINDOW_ID IS_FOCUSED IS_FLOATING WIN_PID <<< "$WIN_DATA"

# Helper function to find the tmux client belonging to this Ghostty instance
get_tmux_client() {
    local target_pid="$1"
    [ -z "$target_pid" ] && return 1
    tmux list-clients -F '#{client_pid} #{client_name}' 2>/dev/null | while read -r cpid cname; do
        local cur="$cpid"
        while [ -n "$cur" ] && [ "$cur" -gt 1 ] 2>/dev/null; do
            if [ "$cur" -eq "$target_pid" ] 2>/dev/null; then
                echo "$cname"
                return 0
            fi
            cur=$(awk '{print $4}' "/proc/$cur/stat" 2>/dev/null)
        done
    done
}

TMUX_CLIENT=$(get_tmux_client "$WIN_PID")
# Fallback to the first client if process tree traversal returns nothing
[ -z "$TMUX_CLIENT" ] && TMUX_CLIENT=$(tmux list-clients -F '#{client_name}' 2>/dev/null | head -n 1)

if [ "$IS_FOCUSED" = "true" ]; then
    # --- STORE TO STASH ---

    # 1. Save current session:window before leaving
    if [ -n "$TMUX_CLIENT" ]; then
        CURRENT_TMUX_TARGET=$(tmux display-message -c "$TMUX_CLIENT" -p '#{session_name}:#{window_index}' 2>/dev/null)
        if [ -n "$CURRENT_TMUX_TARGET" ]; then
            echo "$CURRENT_TMUX_TARGET" > "$STATE_FILE"
        fi

        # 2. Switch scratchpad client to SYSTEM:^
        if ! tmux has-session -t "SYSTEM" 2>/dev/null; then
            tmux new-session -d -s "SYSTEM"
        fi
        tmux switch-client -c "$TMUX_CLIENT" -t "SYSTEM" 2>/dev/null
        tmux select-window -t "SYSTEM:^" 2>/dev/null
    fi

    # 3. Move window to stash workspace FIRST while floating (no layout flicker on screen)
    niri msg action move-window-to-workspace --focus false --window-id "$WINDOW_ID" "stash"

    # 4. Now that it is safely in the stash, unfloat it so it becomes a column
    if [ "$IS_FLOATING" = "true" ]; then
        niri msg action toggle-window-floating --id "$WINDOW_ID" 2>/dev/null
    fi

    # 5. Re-move to stash to force Niri to append it to the VERY END as the last column
    niri msg action move-window-to-workspace --focus false --window-id "$WINDOW_ID" "stash"

else
    # --- SUMMON TO FOCUSED WORKSPACE ---

    # 0. Save the ID of the currently focused window
    PREV_FOCUS=$(niri msg --json windows | jq -r '.[] | select(.is_focused) | .id')
    CURRENT_WS=$(niri msg --json workspaces | jq -r '.[] | select(.is_focused) | (.name // .idx)')

    # 1. Float, resize, and center it IN THE BACKGROUND (while still in stash)
    # Because workspace-to-workspace moves are not animated in Niri, doing the geometry
    # changes before moving makes the window pop in instantly without resizing animations!
    if [ "$IS_FLOATING" = "false" ]; then
        if niri msg action toggle-window-floating --id "$WINDOW_ID" 2>/dev/null; then
            IS_FLOATING="true"
        fi
    fi
    niri msg action set-window-width --id "$WINDOW_ID" "$WIDTH" 2>/dev/null
    niri msg action set-window-height --id "$WINDOW_ID" "$HEIGHT" 2>/dev/null
    niri msg action center-window --id "$WINDOW_ID" 2>/dev/null

    # 2. Bring window to the focused workspace & focus it (instant pop-in)
    niri msg action move-window-to-workspace --window-id "$WINDOW_ID" "$CURRENT_WS"
    niri msg action focus-window --id "$WINDOW_ID"

    # 3. Fallback for older Niri versions if background geometry manipulation failed
    if [ "$IS_FLOATING" = "false" ]; then
        niri msg action toggle-window-floating
        niri msg action set-window-width --id "$WINDOW_ID" "$WIDTH"
        niri msg action set-window-height --id "$WINDOW_ID" "$HEIGHT"
        niri msg action center-window --id "$WINDOW_ID"

        # Restore background focus to undo any tiled layout shift
        if [ -n "$PREV_FOCUS" ] && [ "$PREV_FOCUS" != "null" ] && [ "$PREV_FOCUS" != "$WINDOW_ID" ]; then
            niri msg action focus-window --id "$PREV_FOCUS"
            niri msg action focus-window --id "$WINDOW_ID"
        fi
    else
        # Fast center re-check on active monitor
        niri msg action center-window --id "$WINDOW_ID" 2>/dev/null
    fi

    # 4. Restore previous tmux session for this client
    if [ -n "$TMUX_CLIENT" ] && [ -f "$STATE_FILE" ]; then
        SAVED_TARGET=$(cat "$STATE_FILE")
        SAVED_SESSION="${SAVED_TARGET%%:*}"
        if tmux has-session -t "$SAVED_SESSION" 2>/dev/null; then
            tmux switch-client -c "$TMUX_CLIENT" -t "$SAVED_TARGET" 2>/dev/null
        fi
    fi
fi
