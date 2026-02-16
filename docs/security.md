This is your comprehensive **Hardened CachyOS + Hyprland Security README**. It now includes the global **KeePassXC Secret Service** integration alongside your full security stack.

---

# 🛡️ Hardened CachyOS + Hyprland: Security Stack README

This guide transforms a standard CachyOS installation into a security-hardened workstation using a TUI-centric workflow.

## 1. Core Package Installation
Run this command to install the complete stack:

```bash
sudo pacman -S --needed \
  amd-ucode \          # Use 'intel-ucode' if on Intel
  sbctl \
  fail2ban \
  ufw tufw \
  usbguard \
  apparmor apparmor-profiles \
  lynis arch-audit \
  firejail flatpak flatseal \
  kmon dnscrypt-proxy \
  keepassxc libsecret \
  polkit-kde-agent     # Or your preferred polkit agent
```

---

## 2. Hardware & Boot Hardening
### Microcode & Secure Boot
*   **Microcode:** Verify it is loading: `journalctl -k | grep "microcode"`.
*   **Secure Boot (`sbctl`):**
    1.  Ensure BIOS is in "Setup Mode".
    2.  `sudo sbctl create-keys`
    3.  `sudo sbctl enroll-keys -m`
    4.  `sudo sbctl sign -s /boot/vmlinuz-linux-cachyos` (and any other EFI/boot files).
    5.  Reboot and verify: `sbctl status`.

---

## 3. Mandatory Access Control (AppArmor)
AppArmor restricts application capabilities to prevent exploits from spreading.

1.  **Kernel Parameters:** Edit your bootloader config (e.g., `/etc/default/grub` or systemd-boot). Add:
    `lsm=landlock,lockdown,yama,apparmor,bpf`
2.  **Enable Service:** `sudo systemctl enable --now apparmor.service`
3.  **Enforce Profiles:** `sudo aa-enforce /etc/apparmor.d/*`

---

## 4. Network & Physical Security
### Firewall (`ufw` & `tufw`)
1.  **Configure:**
    ```bash
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw enable
    ```
2.  **Management:** Use the TUI by running `sudo tufw`.

### DNS Encryption (`dnscrypt-proxy`)
1.  **Enable:** `sudo systemctl enable --now dnscrypt-proxy`.
2.  **Network Setup:** Point your NetworkManager DNS to `127.0.0.1`.

### USBGuard (Physical Protection)
**⚠️ WARNING:** Generate a policy before enabling, or your keyboard will be blocked.
1.  **Generate Policy:** `sudo usbguard generate-policy | sudo tee /etc/usbguard/rules.conf`
2.  **Enable:** `sudo systemctl enable --now usbguard`.
3.  **TUI/CLI:** Use `usbguard list-devices` to authorize new devices.

---

## 5. Global Secret Service (KeePassXC)
Replaces insecure keyrings (like GNOME Keyring) with an encrypted database.

1.  **Configure KeePassXC (GUI):**
    *   Open KeePassXC > **Tools > Settings > Secret Service Integration**.
    *   Check **Enable KeePassXC Secret Service**.
    *   Inside your Database: **Database Settings > Secret Service Integration** > Choose a group (e.g., "Root") to expose to the system.
2.  **D-Bus Configuration:** Create `~/.local/share/dbus-1/services/org.freedesktop.secrets.service`:
    ```ini
    [D-BUS Service]
    Name=org.freedesktop.secrets
    Exec=/usr/bin/keepassxc
    ```
3.  **Test:** Run `secret-tool store --label="Test" type manual`. It should prompt KeePassXC to save a secret.

---

## 6. Sandboxing (Firejail & Flatpak)
### Firejail
*   **Usage:** `firejail firefox` (runs Firefox in a restricted sandbox).
*   **Auto-Hardening:** `sudo firecfg` will automatically wrap all supported desktop apps in firejail.

### Flatpak & Flatseal
*   Use **Flatseal** to manage Flatpak permissions. Revoke "Home folder" access for apps that only need "Downloads."

---

## 7. Monitoring & Auditing (TUI Workflow)
Incorporate these into your terminal habits:

*   **Audit Packages:** `arch-audit` (Run daily to find vulnerable software).
*   **System Audit:** `sudo lynis audit system` (Run weekly; aim for a score above 70).
*   **Kernel Watch:** `kmon` (Interactive TUI for monitoring kernel modules).
*   **Log Watch:** `fail2ban-client status` (See who is being banned).

---

## 8. Hyprland Configuration
Add these lines to your `~/.config/hypr/hyprland.conf` to tie everything together:

```conf
# 1. Start KeePassXC (Secret Service) minimized to tray
exec-once = keepassxc

# 2. Start Polkit Agent (for sudo prompts in GUI)
exec-once = /usr/lib/polkit-kde-authentication-agent-1

# 3. Idle management (Screen locking)
exec-once = hypridle

# 4. Cleanup Clipboard (Security precaution)
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
# Clear clipboard every hour via cron or systemd timer if desired
```

---

## Daily Security Checklist
- [ ] Run `arch-audit`.
- [ ] Run `cachyos-update` if vulnerabilities are found.
- [ ] Check `usbguard list-devices` for unauthorized connections.
- [ ] Ensure KeePassXC is unlocked to provide secrets to your apps.
