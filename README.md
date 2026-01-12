# VV OS

<div align="center">

![Version](https://img.shields.io/github/v/release/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=E91E63&logo=github&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-E91E63?style=for-the-badge&labelColor=0C0D11)
![Stars](https://img.shields.io/github/stars/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=E91E63&logo=github&logoColor=white)
![Forks](https://img.shields.io/github/forks/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=00BCD4&logo=github&logoColor=white)
![Issues](https://img.shields.io/github/issues/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=E91E63&logo=github&logoColor=white)
![Last Commit](https://img.shields.io/github/last-commit/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=00BCD4&logo=git&logoColor=white)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white&labelColor=0C0D11)

**Cyberpunk-styled Arch Linux Distribution**

*Hyprland + Noctalia Shell + Gaming Stack*

[Installation](#installation) • [Features](#features) • [Roadmap](#roadmap) • [System Requirements](#system-requirements) • [License](#license)

**[🇷🇺 Русская версия](README.ru.md)**

</div>

---

## About

**VV OS** is a custom Arch Linux distribution with cyberpunk aesthetics, modern Wayland environment, and complete gaming stack. Automated installation and system configuration through an interactive installer.

### Key Features

- **Desktop Environment:** Hyprland (Wayland) + Noctalia Shell (Qt6/QML)
- **Theming:** Material Design 3 with automatic color generation from wallpapers (matugen)
- **Gaming Stack:** GameMode, Lutris, Wine/Proton, Steam, prime-launcher
- **GPU Support:** NVIDIA (full), Intel iGPU (basic)
- **Boot Experience:** CyberGRUB-2077 → Plymouth Cybernetic → SDDM Astronaut
- **Localization:** English / Russian
- **Package Manager:** TUI package manager (gum + paru)

---

## Installation

### Quick Install (Download ISO)

**Download the latest VV OS ISO from [Releases](https://github.com/vaisvaisov/vv-os/releases)**

1. Flash to USB drive (use [Rufus](https://rufus.ie/), [Etcher](https://etcher.balena.io/), or `dd`)
2. Boot from USB
3. Follow the installer
4. Reboot and enjoy!

### Manual Installation (Build ISO yourself)

1. Clone the repository:
```bash
git clone https://github.com/vaisvaisov/vv-os.git
cd vv-os
```

2. Build the ISO:
```bash
cd archiso
sudo ./build.sh
# Result: archiso/out/vv-os-*.iso
```

3. Flash ISO to USB drive:
```bash
# Using dd (Linux)
sudo dd if=archiso/out/vv-os-*.iso of=/dev/sdX bs=4M status=progress

# Or use Rufus (Windows), Etcher (cross-platform)
```

4. Boot from USB and follow the installer
5. Reboot and enjoy!

### Build Your Own ISO

If you want to build your own VV OS ISO image:

```bash
cd archiso
sudo ./build.sh
```

---

## System Requirements

### Minimum Requirements

- **Architecture:** x86_64
- **RAM:** 8 GB (16 GB recommended for gaming)
- **Disk:** 32 GB minimum (SSD recommended)
- **GPU:**
  - NVIDIA GTX 1000+/RTX (full support + gaming)
  - Intel iGPU (basic support)
  - AMD GPU/APU (planned)

### GPU Support

| GPU Type    | Desktop | Gaming | Drivers          | GameMode | Status  |
| ----------- | ------- | ------ | ---------------- | -------- | ------- |
| NVIDIA dGPU | ✅       | ✅      | nvidia-open-dkms | ✅        | Ready   |
| Intel iGPU  | ✅       | ⚠️      | mesa             | ❌        | Basic   |
| AMD dGPU    | ⚠️       | ❌      | -                | ❌        | Planned |
| AMD APU     | ⚠️       | ❌      | -                | ❌        | Planned |

---

## Features

### Desktop Environment

- **Compositor:** Hyprland 0.52.0+ (Wayland)
- **Shell:** Noctalia Shell 3.7.5 (QuickShell/Qt6)
- **Launcher:** Built-in App Launcher + VV Package Manager
- **Notifications:** Noctalia Notification System
- **Wallpapers:** Automatic Material 3 color generation

### Installed Applications

#### Development
- **Editor:** Neovim (LazyVim)
- **Terminal:** Foot + Zsh + Oh-My-Zsh + Powerlevel10k
- **Version Control:** Git, Lazygit
- **Containers:** Docker, Docker Desktop, Lazydocker

#### Gaming
- **Launchers:** Steam, Lutris, XMCL (Minecraft)
- **Performance:** GameMode 1.8.2, prime-launcher
- **Compatibility:** Wine 10.20, Proton, Steam Tinker Launch
- **Tools:** MangoHud, GOverlay

#### System Utilities
- **File Manager:** Nemo
- **Browser:** Chromium
- **Archive:** PeaZip
- **Media:** Celluloid (MPV), Strawberry (Music)
- **Monitor:** neohtop, SystemMonitor
- **Power Management:** TLP + ACPI tools

### Custom Scripts

- `vv-package-manager` — TUI package manager (pacman/AUR)
- `vv-pacman-search` — Search official repositories
- `vv-aur-search` — Search AUR
- `vv-webapp-install` — Install Web Apps (PWA)
- `vv-tui-install` — Install TUI applications
- `update-mirrors.sh` — Update mirrors via rate-mirrors

---

## Roadmap

### 🎮 GPU Support Expansion
- **AMD dGPU** - Drivers, GameMode config, Hyprland environment variables
- **AMD APU** - Optimizations for integrated Radeon Graphics
- **Intel iGPU Gaming** - GameMode config, Vulkan optimizations, power management

### 🎨 Installer: Calamares Migration
- **Cyberpunk GUI installer** with magenta/cyan UI
- **Live ISO with try before install**
- **Multi-language support out of the box** - Calamares supports multiple languages
- **Full installation customization**
- **Direct VV OS integration** into installation process

### 🕹️ Retro Gaming
- **VV ROM Manager** for RetroArch
- Myrient API integration for ROM downloads
- Automatic library organization
- Optional installation via installer

### 📦 OTA Updates System
- **VV Repository for pacman**
- Configs as packages (vv-os-configs, vv-os-themes)
- Updates via `pacman -Syu`
- GitHub Pages hosting

### 📱 VV OS for Android (Long-term Vision)
- **Gaming-focused Android ROM** for turning old phones into retro consoles
- **RetroArch-centered** - classic consoles out of the box
- **Gamepad + Touchscreen controls** - Steam Deck-style input (Bluetooth/USB gamepad support + touch-optimized UI)
- **Cyberpunk UI** in VV OS style + Material 3
- **Second life** for old hardware (Xiaomi, Samsung, etc.)
- Gaming performance optimizations

### 🤝 Community
- **AMD/Intel GPU support** - looking for contributors with hardware for testing
- Custom themes and configs from community
- Device support expansion

---

## Project Structure

```
vv-os/vv-installer/
├── install/              # Installation modules
│   ├── helpers/          # Helper functions
│   ├── preflight/        # Pre-installation checks
│   ├── packaging/        # Package installation
│   ├── config/           # Config deployment
│   ├── login/            # GRUB, Plymouth, SDDM
│   └── post-install/     # Finalization
├── packages/             # Package lists by category
├── configs/              # Configuration files
│   ├── hypr/             # Hyprland
│   ├── noctalia/         # Noctalia Shell
│   ├── applications/     # .desktop files
│   └── scripts/          # System scripts
├── scripts/              # User scripts (vv-*)
├── assets/               # Resources (wallpapers, icons)
├── lang/                 # Localization (EN/RU)
├── install.sh            # Main installer
└── vv-live-installer.sh  # Live ISO wrapper
```

---

## Post-Installation

### First Boot

1. Login to SDDM with your user and password
2. First launch takes 1-2 minutes (generating Material 3 themes from wallpaper)

### Initial Setup

- **Change wallpaper:** Click owl button (top-right) → Control Center → Wallpaper (auto-generates Material 3 colors via matugen)
- **Configure monitors:** Edit `~/.config/hypr/monitor.conf`
- **Update system:** `sudo pacman -Syu` or install `vv-package-manager` from scripts

### Essential Keyboard Shortcuts

**Applications:**
- `Super + Return` - Terminal (foot)
- `Super + F` - File Manager (nemo)
- `Super + B` - Browser (chromium)
- `Super + N` - Neovim
- `Super + T` - Task Manager (NeoHtop)

**Window Management:**
- `Super + Q` - Close window
- `Super + V` - Toggle floating
- `Super + Shift + F` - Fullscreen
- `Super + 1-9,0` - Switch workspace
- `Alt + Tab` - Cycle windows

Full list: `~/.config/hypr/apps.conf`, `~/.config/hypr/tiling.conf`

---

## Troubleshooting

### Black screen after boot (NVIDIA)

If black screen after login:

1. TTY2: `Ctrl+Alt+F2`
2. Login
3. Check logs: `journalctl -xeu nvidia-persistenced`
4. Reinstall: `sudo pacman -S nvidia-open-dkms nvidia-utils`

### WiFi not working

Noctalia Shell should handle it automatically. If not:

```bash
sudo systemctl enable --now NetworkManager
nmtui  # Connect via TUI
```

### Screen tearing / low FPS

Check active GPU:

```bash
nvidia-smi  # For NVIDIA
glxinfo | grep "OpenGL renderer"  # General
```

---

## FAQ

**Q: How to update VV OS?**
A: `sudo pacman -Syu` (updates everything: system + configs)

**Q: Where are configs?**
A: `~/.config/hypr/` (Hyprland), `~/.config/noctalia/` (Shell)

**Q: How to change theme colors?**
A: Control Center (owl button) → Wallpaper → Material 3 auto-generates

**Q: How to install Flatpak apps?**
A: `vv-flatpak-search` or `flatpak install flathub app-id`

**Q: Gaming performance low (NVIDIA)?**
A: Use `prime-launcher`: In Steam launch options add `prime-launcher %command%`

---

## Known Issues (v1.0.0)

- **AMD GPU/APU:** Not yet supported (drivers, GameMode config needed)
- **Intel iGPU:** Basic desktop only, no gaming optimizations yet

---

## Contributing

Contributions are welcome! We especially need help with:

- **AMD GPU/APU support** (author doesn't have AMD hardware for testing)
- **Intel iGPU gaming optimizations**
- **Translations** (currently EN/RU)
- **Testing** on different configurations

### How to contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

**MIT License**

Copyright © 2025 Vais Vaisov

Commercial use, modification, distribution, and private use are permitted.

See [LICENSE](LICENSE) for details.

### Third-Party Components

Some installed themes have GPL licenses:
- Plymouth Cybernetic (GPL)
- SDDM Astronaut (GPL)

GPL components **do not affect** the VV OS installer license, as they are installed as separate packages via pacman.

---

## Credits

- **Inspiration:** [Omarchy](https://github.com/omarchy/omarchy) - for architecture and reference configs
- **Desktop:** [Hyprland](https://hyprland.org/) + [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)
- **Themes:**
  - [CyberGRUB-2077](https://github.com/adnksharp/CyberGRUB-2077)
  - [Plymouth Cybernetic](https://github.com/adi1090x/plymouth-themes)
  - [SDDM Astronaut](https://github.com/Keyitdev/sddm-astronaut-theme)

---

## Contact

- **GitHub:** [@vaisvaisov](https://github.com/vaisvaisov)
- **Issues:** [vv-os/issues](https://github.com/vaisvaisov/vv-os/issues)

---

<div align="center">

**Made with ❤️ for the Linux community**

*VV OS - Arch Linux for Cyberpunk Enthusiasts*

</div>
