To control both your laptop screen and your external monitor **at the same time** (syncing them to one keybind), you need to combine two different technologies: **Backlight control** (for the laptop) and **DDC/CI** (for the external monitor).

### 1. Install Necessary Tools
You need `brightnessctl` for your laptop and `ddcutil` for the external monitor.
```bash
sudo pacman -S brightnessctl ddcutil jq i2c-tools
```

### 2. Set Up Permissions (Critical)
External monitor control requires access to the I2C bus. If you don't do this, `ddcutil` will only work with `sudo`.

1.  **Load the i2c module:**
    ```bash
    echo "i2c-dev" | sudo tee /etc/modules-load.d/i2c.conf
    sudo modprobe i2c-dev
    ```
2.  **Add yourself to the i2c group:**
    ```bash
    sudo usermod -aG i2c $USER
    ```
3.  **Create a udev rule** to allow non-root access:
    ```bash
    echo 'KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"' | sudo tee /etc/udev/rules.d/99-i2c.rules
    sudo udevadm control --reload-rules && sudo udevadm trigger
    ```
    *Note: You must **reboot** or log out/in for the group changes to take effect.*

---

### 3. Create the "Unified Brightness" Script
Since external monitors (DDC/CI) are much slower than laptop screens, calling them directly in a keybind can cause lag. This script runs them in the background so your system stays snappy.

Create a file at `~/.config/hypr/scripts/brightness.sh`:
```bash
#!/bin/bash

# Change amount (e.g., +5 or -5)
STEP=$1

# 1. Update Laptop Backlight (Instant)
brightnessctl set ${STEP#+} %${STEP#-}

# 2. Update External Monitor (Backgrounded to prevent lag)
# 'setvcp 10' is the VCP code for brightness
(ddcutil setvcp 10 $STEP --bus=$(ddcutil detect | grep "I2C bus:" | awk '{print $NF}' | cut -d- -f2) --sleep-multiplier 0) &
```
*Make it executable:* `chmod +x ~/.config/hypr/scripts/brightness.sh`

---

### 4. Configure Hyprland Keybinds
Open your `hyprland.conf` and bind your brightness keys to this new script. Use `binde` (repeatable) so you can hold the key down.

```bash
# Brightness control for both screens
binde = , XF86MonBrightnessUp, exec, ~/.config/hypr/scripts/brightness.sh +5
binde = , XF86MonBrightnessDown, exec, ~/.config/hypr/scripts/brightness.sh -5
```

---

### 💡 Pro Tip: Why "At the same time" can be tricky
External monitors communicate over a slow I2C cable. If you hold down the brightness key, the commands might queue up and make the monitor "lag" behind.

**The Better Alternative: Context-Aware Brightness**
Many Hyprland users prefer to only change the brightness of the **focused** monitor. If you want this instead, change the script to check which monitor is active:

```bash
# Alternative Script logic:
FOCUSED=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ "$FOCUSED" == "eDP-1" ]; then
    brightnessctl set $1%
else
    ddcutil setvcp 10 $1
fi
```

### Summary Checklist
1. **Packages:** `brightnessctl`, `ddcutil`.
2. **Groups:** Your user must be in the `i2c` group.
3. **Monitor Setting:** Ensure **DDC/CI** is enabled in your external monitor's Physical OSD menu (the buttons on the monitor itself). If it's OFF there, no software can control it.
