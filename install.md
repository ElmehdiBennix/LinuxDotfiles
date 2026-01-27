# CachyOS/Arch Full Desktop Environment Setup Guide

This guide provides a reproducible, "God-Tier" workstation setup for **Gaming, Coding, Productivity, and Homelab management**. It uses **Hyprland** as the compositor and **KeePassXC** as the global secret service.

---

## 📋 The Ultimate Package Manifest (`requirements.txt`)
Save this content into a file named `requirements.txt`. Install using: `paru -S --needed - < requirements.txt`.

---

## 🛠 Phase 1: Bootstrapping (Fresh Install)
From a fresh terminal (TTY), install the AUR helper.

```bash
# 1. Update system
sudo pacman -Syu

# 2. Build Paru
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si && cd .. && rm -rf paru

# 3. Bulk Install Everything
paru -S --needed - < requirements.txt

# presets for easyeffects
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/install.sh)"
```

---

## ⚙️ Phase 2: Permissions & Services
Configure the background daemons and user privileges.

```bash
# 1. User Groups (Allow access to hardware without sudo)
sudo usermod -aG video,input,docker,nix-users,lp,render $USER

# 2. Enable Services
sudo systemctl enable ly
sudo systemctl enable --now bluetooth NetworkManager ufw
sudo systemctl enable --now auto-cpufreq thermald cups docker tailscaled apparmor

# 3. Initial Firewall Setup
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# nvidia setup
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

# lan scanning for apps
sudo systemctl enable --now avahi-daemon

```

---

## 🔐 Phase 3: KeePassXC as Global Keyring
Ditch GNOME Keyring and use KeePassXC for all app secrets (Browser, Git, VS Code).

1.  **Open KeePassXC** -> `Tools` -> `Settings` -> `Secret Service Integration`.
2.  Check **"Enable KeePassXC Secret Service"**.
3.  Add the environment variable to your system:
    ```bash
    echo 'SECRET_SERVICE_PATH="/org/freedesktop/secrets"' | sudo tee -a /etc/environment
    ```
4.  **SSH Integration (Optional):** Enable "SSH Agent" in KeePassXC settings and add this to your `.zshrc`:
    ```bash
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keypassxc/ssh-agent.socket"
    ```

---

## 🎨 Phase 4: Desktop Environment Config
Transform the raw packages into a functional DE.

### 1. XDG User Directories
```bash
xdg-user-dirs-update
```

### 2. Nvidia & Wayland Fixes
Add these to your `~/.config/hypr/hyprland.conf` to prevent flickering and ensure performance:
```ini
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = CURSOR_FLAGS,wayland
```

### 3. Essential Autostart (Hyprland)
Add these `exec-once` lines to `hyprland.conf`:
```ini
exec-once = waybar
exec-once = swaync
exec-once = nm-applet --indicator
exec-once = keepassxc
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = udiskie &
exec-once = swayosd-libinput-backend
```

---

## 🛡️ Phase 5: Hardening & Backups

### 1. AppArmor Boot Activation
Edit `/etc/default/grub` (or your bootloader config) and add this to the command line:
`lsm=landlock,lockdown,yama,integrity,apparmor,bpf`
Then run: `sudo grub-mkconfig -o /boot/grub/grub.cfg`.

### 2. Timeshift (The Undo Button)
1. Open **Timeshift**.
2. Select **RSYNC** and pick your backup drive.
3. Set schedule to **Keep 5 Daily**.
4. **Take your first snapshot now.**

### 3. Pacman Maintenance
Prevent your disk from filling up with old package versions:
```bash
# Clean all but the last 3 versions of installed packages
sudo paccache -r
```

---

## 🚀 Phase 6: Maintenance Workflow
Your system is now "Perfect." Maintain it with these simple commands:

*   **Update Everything:** `topgrade`
*   **Manage Game Compatibility:** Use `protonplus` GUI to download GE-Proton.
*   **Audio Tweaks:** Open `easyeffects` to apply presets for your speakers.
*   **Fast Tweaks:** Use `mission-center` (Task Manager) or `gufw` (Firewall) as needed.
