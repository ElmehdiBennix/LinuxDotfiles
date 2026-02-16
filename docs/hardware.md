This README is the definitive guide for setting up an **MSI Laptop (i7 10th Gen + RTX 3060)** on **CachyOS** with **Hyprland**, using **supergfxctl** for seamless GPU switching (no more `prime-run`).

---

# 🚀 MSI RTX 3060 + CachyOS Hyprland Setup

This setup provides high-performance gaming, smooth Wayland animations, and full hardware control for MSI laptops.

## 📦 The Package List
Copy and paste this list to ensure you have everything:
`nvidia-dkms` `nvidia-utils` `lib32-nvidia-utils` `nvidia-vaapi-driver` `libva-utils` `vulkan-icd-loader` `lib32-vulkan-icd-loader` `egl-wayland` `xdg-desktop-portal-hyprland` `qt5-wayland` `qt6-wayland` `intel-media-driver` `intel-ucode` `nvidia-container-toolkit` `msi-ec-git` `supergfxctl`

---

## 🔍 Why These Packages?

### 1. The Switcher (`supergfxctl`)
*   **`supergfxctl`**: The modern alternative to EnvyControl. It manages the GPU state via a background daemon. It allows you to switch between "Integrated" (battery), "Hybrid" (balanced), and "Dedicated" (performance) modes without complex config files.

### 2. Core Drivers & Graphics
*   **`nvidia-dkms`**: The driver itself, set to auto-rebuild whenever the CachyOS kernel updates.
*   **`nvidia-utils` / `lib32-nvidia-utils`**: Essential libraries. `lib32` is required for **Steam** and older games.
*   **`vulkan-icd-loader` / `lib32-vulkan-icd-loader`**: The core API for modern gaming performance.
*   **`intel-ucode` & `intel-media-driver`**: Stability for your i7 CPU and hardware video decoding for your Intel chip (saves battery on YouTube).

### 3. Wayland & Hyprland Essentials
*   **`egl-wayland`**: The "bridge" that lets NVIDIA talk to Wayland.
*   **`xdg-desktop-portal-hyprland`**: Enables screen sharing (Discord/OBS) and file pickers.
*   **`qt5-wayland` & `qt6-wayland`**: Ensures apps like OBS or Dolphin run natively on Wayland.

### 4. MSI & Specialized Tools
*   **`msi-ec-git`**: Provides control over MSI-specific features like battery charge thresholds (e.g., stop charging at 80%) and fan curves.
*   **`nvidia-vaapi-driver`**: Enables the NVIDIA card to handle heavy video encoding/decoding.
*   **`nvidia-container-toolkit`**: Only needed if you use Docker with GPU support.

---

## 🛠️ Installation Guide

### Step 1: Automated Driver Install
Start with CachyOS's hardware detection tool:
```bash
sudo chwd -a pci nonfree 0300
```

### Step 2: Install Remaining Packages
Install the specialized tools and the MSI driver:
```bash
# Core tools and video acceleration
sudo pacman -S libva-utils nvidia-vaapi-driver nvidia-container-toolkit intel-media-driver supergfxctl

# MSI specific driver from AUR
paru -S msi-ec-git
```

### Step 3: Enable Background Services
These services handle GPU switching, sleep/wake stability, and MSI hardware control:
```bash
# Enable the GPU switcher
sudo systemctl enable --now supergfxd

# Fix NVIDIA sleep/resume bugs
sudo systemctl enable --now nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service

# Load the MSI driver
sudo modprobe msi-ec
```

---

## ⚙️ Critical Configuration

### 1. Kernel Parameters
Edit `/etc/default/grub` (or your systemd-boot config). Ensure the following are inside the quotes of the `GRUB_CMDLINE_LINUX_DEFAULT` line:
```text
nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1
```
*After saving, run `sudo update-grub` (or `cachyos-boot-manager update` if using systemd-boot).*

### 2. Hyprland Environment Variables
Add these to the top of your `~/.config/hypr/hyprland.conf`. This tells Hyprland exactly how to use the NVIDIA card.

```bash
# Toolkit Backend Variables
env = GDK_BACKEND,wayland,x11,*
env = QT_QPA_PLATFORM,wayland;xcb
env = SDL_VIDEODRIVER,wayland
env = CLUTTER_BACKEND,wayland

# NVIDIA Specific
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = NVD_BACKEND,direct

# Fix cursor disappearing on NVIDIA
cursor {
    no_hardware_cursors = true
}
```

---

## 🎮 How to use `supergfxctl` (No `prime-run` needed)

Instead of using `prime-run` for every game, you can just set the whole system's state.

1.  **To check your current mode:**
    `supergfxctl -g`

2.  **To switch to Gaming Mode (Dedicated NVIDIA):**
    `supergfxctl -m dgpu`
    *(Note: You will need to log out and back into Hyprland. In this mode, EVERY app uses the 3060. No commands required.)*

3.  **To switch to Balanced Mode (Hybrid):**
    `supergfxctl -m hybrid`
    *(Standard laptop behavior. Uses Intel for desktop, NVIDIA for games via internal logic.)*

4.  **To switch to Battery Mode (Integrated):**
    `supergfxctl -m integrated`
    *(Completely powers off the RTX 3060 to save battery.)*

---

## ✅ Final Verification
Run these commands to ensure everything is perfect:
*   `nvidia-smi` — Should show your RTX 3060.
*   `vainfo` — Should show "VA-API version 1.x.x" (Hardware acceleration check).
*   `supergfxctl -s` — Should show the status of your GPU switcher.
