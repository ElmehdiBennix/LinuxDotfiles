To set these up correctly on CachyOS, you need to install the packages and then add specific lines to your `hyprland.conf` file to ensure they initialize and function properly.

### Step 1: Install the Packages
Run the following command in your terminal. CachyOS repositories are optimized, so these versions will be the fastest for your hardware:
```bash
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xwaylandvideobridge
```

### Step 2: Configure `hyprland.conf`
Open your configuration file (usually at `~/.config/hypr/hyprland.conf`) and add the following sections:

#### 1. Essential Environment Setup
Add these lines at the beginning of your file. They tell the system that you are running Hyprland, which is required for screen sharing and file pickers to "find" the right portal.
```bash
# Set environment variables
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Import variables into systemd and dbus
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
```

#### 2. XWayland Video Bridge Setup
The video bridge is a "ghost" window that passes video data to apps like Discord. Without these rules, it will show up as a weird white square on your screen. Add these rules to your **Window Rules** section:
```bash
windowrulev2 = opacity 0.0 override, class:^(xwaylandvideobridge)$
windowrulev2 = noanim, class:^(xwaylandvideobridge)$
windowrulev2 = noinitialfocus, class:^(xwaylandvideobridge)$
windowrulev2 = maxsize 1 1, class:^(xwaylandvideobridge)$
windowrulev2 = nofocus, class:^(xwaylandvideobridge)$
windowrulev2 = float, class:^(xwaylandvideobridge)$
```
*Note: Also add `exec-once = xwaylandvideobridge` to start it automatically on login.*

### Step 3: Troubleshooting (The "Nuclear" Option)
If you find that screen sharing or file pickers are still not working (or taking a long time to load), you can force-restart the portals in your config. Add this script snippet:
```bash
exec-once = sleep 1 && killall -e xdg-desktop-portal-hyprland && killall xdg-desktop-portal && /usr/lib/xdg-desktop-portal-hyprland & sleep 2 && /usr/lib/xdg-desktop-portal &
```

### Verification
*   **Screen Sharing:** Open OBS or a browser (Firefox/Chrome) and try to share a window. A "share picker" menu should pop up.
*   **File Pickers:** Try to upload a file in a GTK app like Firefox. It should use the system file picker instead of a generic one.
*   **XWayland:** In Discord (installed via Pacman/AUR, not Flatpak), try to share your screen. You should now see Wayland windows as options.
