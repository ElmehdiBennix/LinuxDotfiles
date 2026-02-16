
# 🎮 Ultimate CachyOS + Hyprland Gaming Setup

This guide outlines the configuration and packages required for a high-performance, modern gaming experience on CachyOS using the Hyprland compositor. This setup leverages CachyOS’s **x86-64-v3/v4** optimizations and Wayland-native tools.

## 🚀 1. Core System Packages

First, install the base gaming stack provided by CachyOS. This includes optimized kernels, wine-cachyos, and essential libraries.

```bash
sudo pacman -S cachyos-gaming-meta cachyos-gaming-applications
```

## 🕹️ 2. Primary Launchers & Tooling

We are using **Hydra** as the modern library aggregator and **Proton Plus** for compatibility layer management.

### **The Launchers**
*   **Hydra Launcher**: A modern, fast, and feature-rich game launcher (perfect for managing large libraries and repacks).
*   **Steam**: The gold standard for Linux gaming.
*   **Heroic Games Launcher**: For Epic Games, GOG, and Amazon Games.

```bash
# Install Hydra and Proton Plus
sudo pacman -S hydra-game-launcher-bin proton-plus

# Install additional store support
sudo pacman -S steam heroic-games-launcher-bin
```

### **The Utilities**
*   **Proton Plus**: Use this to download the latest **GE-Proton** or **Wine-GE** versions. It features a clean GTK4 interface that looks great on Hyprland.
*   **MangoHud**: An advanced Vulkan/OpenGL overlay for monitoring FPS, temperatures, and CPU/GPU usage.
*   **GOverlay**: A GUI to easily configure MangoHud settings.
*   **Gamescope**: A micro-compositor from Valve that allows for resolution upscaling (FSR) and better window handling.

```bash
sudo pacman -S mangohud goverlay gamescope
```

---

## 🖥️ 3. Hyprland Configuration (`hyprland.conf`)

To ensure smooth gaming without stuttering or input lag, add these settings to your `~/.config/hypr/hyprland.conf`.

### **Variable Refresh Rate (VRR)**
Essential for eliminating screen tearing while maintaining smoothness.
```ini
monitor=DP-1, 2560x1440@144, 0x0, 1, vrr, 1
```

### **Tearing Control (Ultra-Low Latency)**
For competitive games (CS2, Valorant via VM, etc.), you can allow "Immediate" page flipping.
```ini
general {
    allow_tearing = true
}

# Apply tearing only to full-screen games
windowrulev2 = immediate, class:^(steam_app_.*)$
windowrulev2 = immediate, class:^(hydra)$
```

### **Workaround for Hydra/Steam Popups**
```ini
windowrulev2 = float, class:^(proton-plus)$
windowrulev2 = float, title:^(Steam Settings)$
```

---

## 🛠️ 4. Performance Optimizations

### **GameMode**
CachyOS comes with GameMode. To ensure it runs, add it to your Steam launch options or Hydra settings:
`gamemoderun %command%`

### **Gamescope (The Secret Sauce)**
If a game has trouble with Wayland or you want to use FSR upscaling:
`gamescope -W 2560 -H 1440 -f -r 144 -- %command%`

---

## 🎮 5. Peripherals & Audio

### **Audio (Pipewire)**
CachyOS uses Pipewire by default. To manage audio visually:
```bash
sudo pacman -S helvum pavucontrol
```

### **Controllers**
*   **Xbox**: `sudo pacman -S xpadneo-dkms` (Bluetooth) or `xone-dkms` (USB Dongle).
*   **Playstation**: Works natively; use `ds4windows` or `input-remapper-git` for remapping.

---

## 📝 6. Post-Install Checklist

1.  **Open Proton Plus**: Download the latest **GE-Proton** (for Steam) and **Wine-GE** (for Hydra/Heroic).
2.  **Open Hydra Launcher**: Point your game directories to your library folders.
3.  **MangoHud**: Run `goverlay` to set up your preferred HUD layout (e.g., top-left, compact).
4.  **CachyOS Kernel**: Ensure you are booted into the `linux-cachyos` kernel for the best scheduler performance (`uname -r`).

---

### **Useful Commands**
*   **Check if VRR is working:** `hyprctl monitors`
*   **Check if GameMode is active:** `gamemoded -s`
*   **Update everything:** `cachyos-rate-mirrors && sudo pacman -Syu`
