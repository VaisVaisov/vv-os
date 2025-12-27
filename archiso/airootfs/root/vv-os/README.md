# VV OS

<div align="center">

**Cyberpunk-styled Arch Linux Distribution**

*Hyprland + Noctalia Shell + Gaming Stack*

[Installation](#installation) • [Features](#features) • [Screenshots](#screenshots) • [System Requirements](#system-requirements) • [License](#license)

</div>

---

## О проекте

**VV OS** — кастомный дистрибутив на базе Arch Linux с cyberpunk эстетикой, современным Wayland окружением и полным gaming стеком. Автоматическая установка и настройка всей системы через интерактивный installer.

### Ключевые особенности

- **Desktop Environment:** Hyprland (Wayland) + Noctalia Shell (Qt6/QML)
- **Theming:** Material Design 3 с автогенерацией цветов из обоев (matugen)
- **Gaming Stack:** GameMode, Lutris, Wine/Proton, Steam, prime-launcher
- **GPU Support:** NVIDIA (полная), Intel iGPU (базовая)
- **Boot Experience:** CyberGRUB-2077 → Plymouth Cybernetic → SDDM Astronaut
- **Локализация:** English / Русский
- **Package Manager:** TUI менеджер пакетов (gum + paru)

---

## Screenshots

> **Coming soon!** Скриншоты будут добавлены после первой стабильной сборки

---

## Installation

### Быстрая установка (из Arch Live ISO)

```bash
curl -sL https://raw.githubusercontent.com/vaisvaisov/vv-os/main/boot.sh | bash
```

### Ручная установка

1. Загрузите [Arch Linux Live ISO](https://archlinux.org/download/)
2. Подключитесь к интернету
3. Клонируйте репозиторий:

```bash
git clone https://github.com/vaisvaisov/vv-os.git
cd vv-os
chmod +x vv-live-installer.sh
./vv-live-installer.sh
```

4. Следуйте инструкциям установщика
5. Перезагрузитесь и выберите Hyprland в SDDM

### Сборка собственного ISO

Если хотите собрать собственный ISO образ VV OS:

```bash
cd archiso
sudo ./build.sh
```

Подробные инструкции см. в [archiso/README.md](archiso/README.md)

---

## System Requirements

### Минимальные требования

- **Архитектура:** x86_64
- **RAM:** 8 GB (16 GB рекомендуется для gaming)
- **Диск:** 50 GB (SSD рекомендуется)
- **GPU:** 
  - NVIDIA GTX 1000+/RTX (полная поддержка + gaming)
  - Intel iGPU (базовая поддержка)
  - AMD GPU/APU (в планах)

### GPU Support

| GPU Type | Desktop | Gaming | Драйверы | GameMode | Статус |
|----------|---------|--------|----------|----------|--------|
| NVIDIA dGPU | ✅ | ✅ | nvidia-dkms | ✅ | Готово |
| Intel iGPU | ✅ | ⚠️ | mesa | ❌ | Базовая |
| AMD dGPU | ⚠️ | ❌ | - | ❌ | Planned |
| AMD APU | ⚠️ | ❌ | - | ❌ | Planned |

---

## Features

### Desktop Environment

- **Compositor:** Hyprland 0.52.0+ (Wayland)
- **Shell:** Noctalia Shell 3.7.5 (QuickShell/Qt6)
- **Launcher:** Встроенный App Launcher + VV Package Manager
- **Notifications:** Noctalia Notification System
- **Wallpapers:** Автоматическая генерация Material 3 цветов

### Installed Applications

#### Development
- **Editor:** Neovim (LazyVim)
- **Terminal:** Foot + Zsh + Oh-My-Zsh + Powerlevel10k
- **Version Control:** Git, Lazygit
- **Containers:** Docker, Docker Compose, Lazydocker

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
- **Monitor:** btop, SystemMonitor

### Custom Scripts

- `vv-package-manager` — TUI менеджер пакетов (pacman/AUR)
- `vv-pacman-search` — Поиск в официальных репозиториях
- `vv-aur-search` — Поиск в AUR
- `vv-webapp-install` — Установка Web Apps (PWA)
- `vv-tui-install` — Установка TUI приложений
- `update-mirrors.sh` — Обновление зеркал через rate-mirrors

---

## Project Structure

```
vv-os/
├── install/              # Модули установки
│   ├── helpers/          # Helper функции
│   ├── preflight/        # Проверки перед установкой
│   ├── packaging/        # Установка пакетов
│   ├── config/           # Копирование конфигов
│   ├── login/            # GRUB, Plymouth, SDDM
│   └── post-install/     # Финализация
├── packages/             # Списки пакетов по категориям
├── configs/              # Конфигурационные файлы
│   ├── hypr/             # Hyprland
│   ├── noctalia/         # Noctalia Shell
│   ├── applications/     # .desktop файлы
│   └── scripts/          # Системные скрипты
├── scripts/              # Пользовательские скрипты (vv-*)
├── assets/               # Ресурсы (обои, иконки)
├── lang/                 # Локализация (EN/RU)
├── install.sh            # Главный установщик
├── vv-live-installer.sh  # Wrapper для Live ISO
└── boot.sh               # Онлайн установщик
```

---

## Contributing

Вклад в проект приветствуется! Особенно нужна помощь с:

- **AMD GPU/APU поддержкой** (у автора нет AMD hardware для тестирования)
- **Intel iGPU gaming оптимизациями**
- **Переводами** (сейчас EN/RU)
- **Тестированием** в разных конфигурациях

### How to contribute

1. Fork репозиторий
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

---

## License

**MIT License**

Copyright © 2025 Vais Vaisov

Разрешено коммерческое использование, модификация, распространение и приватное использование.

См. [LICENSE](LICENSE) для подробностей.

### Third-Party Components

Некоторые устанавливаемые темы имеют GPL лицензию:
- Plymouth Cybernetic (GPL)
- SDDM Astronaut (GPL)
- CyberGRUB-2077 (GPL)

GPL компоненты **не влияют** на лицензию VV OS installer, так как они устанавливаются как отдельные пакеты через pacman.

---

## Roadmap

### v1.0 (Current)
- ✅ Базовая установка через archinstall
- ✅ Hyprland + Noctalia Shell
- ✅ NVIDIA GPU полная поддержка
- ✅ Gaming стек (GameMode, Steam, Lutris)
- ✅ TUI Package Manager
- ✅ Material 3 theming

### v1.1 (Planned)
- 📋 AMD dGPU support
- 📋 AMD APU gaming оптимизации
- 📋 Intel iGPU gaming оптимизации
- 📋 archiso профиль (собственный ISO)
- 📋 VV repository для pacman
- 📋 Дополнительные локализации

---

## Credits

- **Inspiration:** [Omarchy](https://github.com/omarchy/omarchy) - за архитектуру и референсные конфиги
- **Desktop:** [Hyprland](https://hyprland.org/) + [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)
- **Themes:** 
  - [CyberGRUB-2077](https://github.com/Cyber-Dioxide/CyberGRUB-2077)
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
