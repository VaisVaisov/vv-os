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

[Installation](#installation) • [Features](#features) • [Roadmap](#roadmap) • [System Requirements](#system-requirements)

**[🇷🇺 Русская версия](README.ru.md)**

</div>

---

## What is VV OS?

**VV OS** is a custom Arch Linux distribution designed for cyberpunk enthusiasts and gamers. It combines cutting-edge Wayland technology (Hyprland compositor + Noctalia Shell) with a complete gaming stack and automatic Material Design 3 theming.

Boot into a fully functional GUI Live environment straight from the ISO—try it before installing!

### Why VV OS?

- 🎮 **Gaming-ready**: GameMode, Steam, Lutris, Wine/Proton configured out of the box
- 🎨 **Beautiful**: Material Design 3 with colors auto-generated from your wallpaper
- 🚀 **Modern**: Latest Hyprland on Wayland with smooth animations
- 🔧 **NVIDIA-optimized**: Full support with gaming tweaks
- 💎 **Cyberpunk aesthetic**: CyberGRUB → Plymouth → SDDM with cyberpunk themes
- 🖥️ **Live GUI**: Full desktop environment in Live ISO — no terminal required

---

## Installation

### Method 1: Download ISO (Recommended)

**Grab the latest ISO from [Releases](https://github.com/vaisvaisov/vv-os/releases)**

1. **Flash to USB** (8GB+ recommended):
   ```bash
   # Linux
   sudo dd if=vv-os-*.iso of=/dev/sdX bs=4M status=progress && sync

   # Or use Rufus (Windows) / Etcher (cross-platform)
   ```

2. **Boot from USB**: Select USB in BIOS/UEFI boot menu

3. **Try or Install**:
   - **Try first**: Boots into Hyprland with autologin—explore the system!
   - **Ready to install?**: Launch "Install VV OS" from Noctalia Launcher (rocket button top-left or SUPER+Space) or run:
     ```bash
     sudo vv-live-installer.sh
     ```

4. **Follow TUI installer**: Select disk, create user, configure system

5. **Reboot** and enjoy your new cyberpunk-style desktop!

### Method 2: Build Your Own ISO

Want to customize before installing? Build it yourself:

```bash
git clone https://github.com/vaisvaisov/vv-os.git
cd vv-os/archiso
sudo ./build.sh
# Result: archiso/out/vv-os-YYYY.MM.DD-x86_64.iso
```

Then follow Method 1 with your custom ISO.

---

## System Requirements

### Minimum Specs

- **CPU**: x86_64 (64-bit)
- **RAM**: 8 GB (16 GB for gaming)
- **Disk**: 32 GB minimum (SSD strongly recommended)
- **GPU**: See table below

### GPU Support Status

| GPU Type        | Desktop | Gaming | Drivers          | GameMode | Status        |
| --------------- | ------- | ------ | ---------------- | -------- | ------------- |
| **NVIDIA dGPU** | ✅       | ✅      | nvidia-open-dkms | ✅        | Full support  |
| **Intel iGPU**  | ✅       | ⚠️      | mesa             | ❌        | Basic support |
| **AMD dGPU**    | ⚠️       | ❌      | -                | ❌        | Planned       |
| **AMD APU**     | ⚠️       | ❌      | -                | ❌        | Planned       |

**Note**: Desktop works on Intel/AMD, but gaming optimizations are NVIDIA-only for now. AMD support is planned—[contributors welcome](#contributing)!

---

## Features

### Desktop Environment

- **Compositor**: Hyprland (Wayland) with smooth animations
- **Shell**: Noctalia Shell (Qt6/QML)—beautiful and functional
- **Theming**: Material Design 3 colors auto-generated from wallpapers via `matugen`
- **Boot flow**: CyberGRUB-2077 → Plymouth Cybernetic → SDDM Astronaut (cyberpunk theme)

### Pre-installed Apps

#### Development Tools
- **Editor**: Neovim with LazyVim config
- **Terminal**: Foot + Zsh + Oh-My-Zsh + Powerlevel10k
- **Git**: Git, Lazygit (TUI client)
- **Containers**: Docker, Docker Desktop, Lazydocker (TUI client)

#### Gaming Stack
- **Launchers**: Steam, Lutris, XMCL (Minecraft)
- **Performance**: GameMode, prime-launcher (NVIDIA)
- **Compatibility**: Wine, Proton, Steam Tinker Launch
- **Overlays**: MangoHud, GOverlay

#### Daily Use
- **Files**: Nemo
- **Browser**: Chromium
- **Media**: Celluloid (video), Strawberry (music)
- **Archives**: PeaZip
- **Monitor**: neohtop
- **Power**: TLP with auto-tweaks

### Custom Scripts

Run these from terminal:

- `vv-package-manager` — TUI for pacman/AUR packages
- `vv-pacman-search` — Search official repos
- `vv-aur-search` — Search AUR
- `vv-flatpak-search` — Search/install Flatpak apps
- `vv-webapp-install` — Install web apps as PWAs
- `vv-tui-install` — Install TUI applications
- `update-mirrors.sh` — Update mirrorlist via rate-mirrors

---

## Post-Installation

### First Boot

1. **Login**: SDDM takes you straight to Hyprland
2. **Wait 1-2 minutes**: First launch generates Material 3 themes from wallpaper

### Quick Setup

- **Change wallpaper**: Click owl button (top-right) → Control Center → Wallpaper
  *(Colors regenerate automatically!)*
- **Configure monitors**: Edit `~/.config/hypr/monitor.conf`
- **Update system**: Run `sudo pacman -Syu`

### Keyboard Shortcuts

**Apps**:
- `Super + Return` → Terminal
- `Super + F` → File Manager
- `Super + B` → Browser
- `Super + N` → Neovim
- `Super + T` → System Monitor

**Windows**:
- `Super + Q` → Close window
- `Super + V` → Toggle floating
- `Super + Shift + F` → Fullscreen
- `Super + 1-9` → Switch workspace
- `Alt + Tab` → Cycle windows

Full list in `~/.config/hypr/apps.conf` and `~/.config/hypr/tiling.conf`

---

## Troubleshooting

### Black screen after login (NVIDIA)

1. Press `Ctrl+Alt+F2` to switch to TTY2
2. Login with your username/password
3. Check logs: `journalctl -xeu nvidia-persistenced`
4. Reinstall drivers: `sudo pacman -S nvidia-open-dkms nvidia-utils`
5. Reboot: `sudo reboot`

### WiFi not connecting

Noctalia Shell should handle this automatically. If not:

```bash
sudo systemctl enable --now NetworkManager
nmtui  # Connect via TUI
```

### Low FPS in games (NVIDIA)

Use `prime-launcher` to force dedicated GPU:

1. Open Steam
2. Right-click game → Properties → Launch Options
3. Add: `prime-launcher %command%`

---

## Roadmap

### v1.1.x: Custom GUI Installer
- Beautiful cyberpunk-themed graphical installer (Python + PySide6)
- Package selection with checkboxes
- Multi-language support
- "Try before install" live environment

### v2.0.0: Major Update - VV OS for Android
- LineageOS-based custom ROM with cyberpunk aesthetics
- Gaming optimizations for mobile devices
- Desktop ↔ Android synchronization via **VV Connect**
- Turn old phones into retro gaming consoles

#### VV Connect - Desktop ↔ Android Synchronization

A full-featured [KDE Connect](https://kdeconnect.kde.org/) analog for the VV OS ecosystem with cyberpunk UI. Seamlessly connect your VV OS Desktop and Android devices:

- **Clipboard Sync**: Copy on phone → paste on PC (with cliphist history sync)
- **File Transfer**: Share files between devices with cyberpunk UI
- **Notifications**: Android notifications appear on Desktop
- **Media Control**: Control RetroArch/music on PC from your phone
- **Remote Input**: Use phone as touchpad/keyboard
- **SMS Integration**: Send SMS from Desktop
- **Battery Monitor**: View phone battery status on PC
- **Theme Sync**: Material 3 themes sync across devices (pick wallpaper → applies everywhere)
- **Config Sync**: Synchronize configurations between Desktop and Android

Alternative name under consideration: **VV Sync**

### Future Plans

- **AMD GPU Support**: AMD dGPU drivers, GameMode config, APU optimizations (need hardware for testing)
- **Intel iGPU Gaming**: Gaming optimizations for Intel integrated graphics
- **VV ROM Manager**: RetroArch ROM downloader with Myrient API integration
- **OTA Updates**: Custom pacman repository for config updates

---

## Known Issues (v1.0.3)

- **AMD GPU/APU**: Not yet supported (need drivers + testing)
- **Intel iGPU**: Desktop works, but no gaming optimizations yet

---

## Contributing

Help us make VV OS better! We especially need:

- **AMD hardware owners**: Test and help implement AMD GPU/APU support
- **Intel GPU owners**: Test gaming performance and help optimize
- **Translators**: Add more languages (currently EN/RU)
- **Testers**: Try VV OS on different hardware configs

### How to contribute

1. Fork the repo
2. Create branch: `git checkout -b feature/cool-feature`
3. Commit: `git commit -m 'Add cool feature'`
4. Push: `git push origin feature/cool-feature`
5. Open Pull Request

---

## License

**MIT License** — Copyright © 2025-2026 Vais Vaisov

Free to use, modify, and distribute commercially or privately.

### Third-party Components

Some themes use GPL licenses (Plymouth, SDDM). They're installed as separate packages and don't affect the VV OS installer license.

---

## Credits

- **Inspired by**: [Omarchy](https://github.com/basecamp/omarchy)
- **Desktop**: [Hyprland](https://hyprland.org/) + [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)
- **Themes**: [CyberGRUB-2077](https://github.com/adnksharp/CyberGRUB-2077) • [Plymouth Cybernetic](https://github.com/adi1090x/plymouth-themes) • [SDDM Astronaut](https://github.com/Keyitdev/sddm-astronaut-theme)

---

## Contact

- **GitHub**: [@vaisvaisov](https://github.com/vaisvaisov)
- **Issues**: [Report bugs or request features](https://github.com/vaisvaisov/vv-os/issues)

---

<div align="center">

**Made with ❤️ for the Linux community**

*VV OS — Arch Linux for Cyberpunk Enthusiasts*

</div>
