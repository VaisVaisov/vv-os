# VV OS Packages

Описание всех устанавливаемых пакетов VV OS.

---

## Обзор

VV OS устанавливает **117 пакетов** из **13 категорий**:
- Official Arch repos: ~70 пакетов
- AUR: ~47 пакетов

**Расположение:** `/workspaces/vv-os/packages/*.txt`

---

## Категории пакетов

### base.txt - Базовые системные пакеты

Основные пакеты для работы системы.

**Примеры:**
- `base`, `base-devel` - базовая система и инструменты разработки
- `linux`, `linux-firmware` - ядро и прошивки
- `grub`, `efibootmgr` - загрузчик
- `networkmanager`, `dhcpcd` - сеть
- `pipewire`, `wireplumber` - аудио сервер

### desktop.txt - Desktop Environment

Компоненты рабочего окружения.

**Основные:**
- `hyprland` - Wayland compositor
- `noctalia-shell-git` - Оболочка (QuickShell/QML)
- `quickshell-git` - QML runtime для Noctalia
- `qt6-base`, `qt6-declarative` - Qt6 библиотеки
- `polkit-kde-agent` - PolicyKit агент
- `xdg-desktop-portal-hyprland` - Desktop portal

**Вспомогательные:**
- `wl-clipboard`, `cliphist` - буфер обмена
- `grim`, `slurp` - скриншоты
- `foot` - терминал

### gaming.txt - Игровой стек

Всё для gaming на Linux.

**Launchers:**
- `lutris` - универсальный launcher
- `steam` - Steam client
- `xmcl-launcher` - Minecraft launcher
- `an-anime-game-launcher-bin` - Genshin Impact

**Wine/Proton:**
- `wine` 10.20-2 - Windows эмуляция
- `wine-mono`, `wine-gecko` - зависимости Wine
- `winetricks` - настройка Wine
- `lib32-*` - 32-bit библиотеки для Wine

**Optimization:**
- `gamemode`, `lib32-gamemode` 1.8.2-1 - оптимизация системы для игр
- `steamtinkerlaunch` 12.12-1 - управление GameMode, MangoHud
- `prime-launcher` (custom script) - NVIDIA GPU оптимизации

**Vulkan:**
- `vulkan-tools` - утилиты Vulkan
- `lib32-vulkan-icd-loader` - 32-bit Vulkan loader

### theming.txt - Темы, иконки, шрифты

Material 3 theming и визуальное оформление.

**Material 3:**
- `matugen` - генератор палитр из изображений
- `python-materialyoucolor` - Material You color library
- `adw-gtk-theme` - GTK тема Material Design 3

**Иконки:**
- `papirus-icon-theme` - набор иконок Papirus

**Fonts:**
- `ttf-jetbrains-mono-nerd` - моноширинный шрифт с иконками
- `ttf-font-awesome` - иконочный шрифт
- `noto-fonts`, `noto-fonts-emoji` - Unicode шрифты

**Boot themes:**
- `plymouth`, `plymouth-themes-adi1090x-git` - boot screen (тема cybernetic)
- `sddm` + astronaut theme - display manager
- CyberGRUB-2077 - GRUB тема (клонируется runtime)

### development.txt - Dev Tools

Инструменты разработки.

**Editors:**
- `neovim` - LazyVim configured

**Version Control:**
- `git`, `lazygit` - Git и TUI

**Containers:**
- `docker`, `docker-compose` - контейнеризация
- `lazydocker` - Docker TUI

**Languages:**
- `python`, `python-pip`
- `nodejs`, `npm`
- `rustup` (опционально)

**IDEs:**
- `clion-bin` (опционально) - JetBrains C/C++ IDE

### multimedia.txt - Медиа приложения

Приложения для работы с медиа.

**Архиватор:**
- `peazip-gtk2-bin` - архиватор с поддержкой 200+ форматов, AES-256

**Видео:**
- `celluloid` - MPV GUI (GTK4)
- `mpv` - медиаплеер

**Музыка:**
- `strawberry` - музыкальный плеер для аудиофилов

**Изображения:**
- `imv` - просмотрщик изображений

### utilities.txt - Системные утилиты

Полезные системные утилиты.

**File Manager:**
- `nemo` - файловый менеджер

**Browser:**
- `chromium` - веб-браузер

**System Monitor:**
- `btop` - системный монитор

**Дополнительно:**
- `gum` - интерактивные меню для bash
- `bat` - cat с подсветкой синтаксиса
- `eza` - улучшенный ls
- `zoxide` - умный cd

### shell.txt - Shell окружение

Настройки командной оболочки.

**Shell:**
- `zsh` - Z shell
- `oh-my-zsh` - фреймворк для zsh
- `powerlevel10k` - тема для zsh

**Plugins:**
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`

### gpu.txt - GPU драйверы

Драйверы для видеокарт.

**NVIDIA (✅ Полная поддержка):**
- `nvidia-dkms` - драйверы NVIDIA (latest)
- `nvidia-utils`, `nvidia-settings` - утилиты
- `lib32-nvidia-utils` - 32-bit поддержка для Wine/Proton

**Intel iGPU (⚠️ Базовая поддержка):**
- `mesa`, `lib32-mesa` - Mesa драйверы
- `vulkan-intel` - Vulkan для Intel

**AMD (❌ Пока не поддерживается):**
- Будет добавлено в будущем

### network.txt - Сетевые утилиты

Сетевые инструменты.

- `networkmanager` - управление сетью
- `nm-connection-editor` - GUI для NetworkManager
- `openssh` - SSH клиент/сервер
- `sshpass` - SSH с паролем из командной строки

### security.txt - Безопасность

Инструменты безопасности.

- `polkit` - PolicyKit
- `gnome-keyring` - хранилище паролей
- `seahorse` - GUI для gnome-keyring

### bluetooth.txt - Bluetooth

Поддержка Bluetooth.

- `bluez`, `bluez-utils` - Bluetooth стек
- `blueman` - Bluetooth manager

### printer.txt - Печать

Поддержка принтеров (опционально).

- `cups` - система печати
- `system-config-printer` - настройка принтеров

---

## Пользовательские скрипты

Кастомные скрипты VV OS (не в pacman).

**Расположение:** `/workspaces/vv-os/scripts/`

| Скрипт | Описание |
|--------|----------|
| `vv-launch-or-focus` | Фокус на существующее окно или запуск приложения |
| `vv-launch-webapp` | Запуск web app через браузер |
| `vv-launch-tui` | Запуск TUI приложения в терминале |
| `vv-webapp-install` | Создание ярлыка для web app |
| `vv-tui-install` | Создание ярлыка для TUI app |
| `prime-launcher` | GameMode + NVIDIA GPU launcher для игр |
| `update-mirrors.sh` | Обновление pacman зеркал через rate-mirrors |

**Установка:** Копируются в `~/.local/bin/` модулем `02-configs.sh`

---

## Управление пакетами

### Установка

Пакеты устанавливаются модулем `01-packages.sh`:

```bash
# 1. Official repo пакеты (через pacman)
pacman -S --noconfirm package1 package2

# 2. AUR пакеты (через paru)
paru -S --noconfirm package1-bin package2-git
```

### Обновление

```bash
# Обновить всю систему + AUR
paru -Syu

# Только official repos
sudo pacman -Syu
```

### Удаление

```bash
# Удалить пакет
sudo pacman -R package

# Удалить пакет и зависимости
sudo pacman -Rs package

# Удалить пакет, зависимости и конфиги
sudo pacman -Rns package
```

### Поиск

```bash
# Поиск в official repos
pacman -Ss keyword

# Поиск в AUR
paru -Ss keyword

# Информация о пакете
pacman -Si package    # official
paru -Si package      # AUR
```

---

## AUR Helper: paru

VV OS использует **paru** как основной AUR helper.

**Преимущества paru:**
- Нативная поддержка libalpm v16
- Интеграция с Arch News
- Просмотр diff PKGBUILD через bat
- Больше функций для управления пакетами

**Альтернатива:** yay v12.5.6 (резервный, тоже поддерживает libalpm v16)

### Полезные команды paru

```bash
# Установка с проверкой PKGBUILD
paru -S package

# Показать AUR пакеты
paru -Qm

# Очистка кэша
paru -Sc     # умная очистка
paru -Scc    # полная очистка

# Обновление без подтверждения
paru -Syu --noconfirm
```

---

## GPU-специфичные пакеты

### NVIDIA (✅ Полная поддержка)

**Обязательные:**
```
nvidia-dkms
nvidia-utils
lib32-nvidia-utils
```

**Опционально:**
```
cuda              # для ML/AI
nvidia-container-toolkit  # для Docker GPU
```

**Конфигурация:**
- Hyprland env.conf - NVIDIA environment variables
- GameMode конфиг - NVIDIA PowerMizer mode 1
- prime-launcher - custom скрипт для NVIDIA GPU

### Intel iGPU (⚠️ Базовая поддержка)

**Обязательные:**
```
mesa
lib32-mesa
vulkan-intel
```

**Что НЕ настроено:**
- GameMode оптимизации для Intel
- Power management для ноутбуков

### AMD (❌ Планируется)

**Будет добавлено:**
```
mesa
lib32-mesa
vulkan-radeon
lib32-vulkan-radeon
amdgpu (kernel module)
```

---

## Версии ПО (критичные)

| Компонент | Версия | Важность |
|-----------|--------|----------|
| pacman | 7.1.0 | libalpm v16 (breaking changes) |
| libalpm | 16.0.1 | Breaking API changes |
| paru | 2.1.0-2 | Нативная поддержка libalpm v16 |
| yay | 12.5.6-1 | Поддержка libalpm v16 |
| hyprland | 0.52.0 | Новый синтаксис жестов (0.51+) |
| noctalia-shell | 3.7.5 | QuickShell-based shell |
| quickshell | 0.2.1 | QML/Qt6 runtime |
| gamemode | 1.8.2-1 | Gaming optimization |
| wine | 10.20-2 | Windows compatibility |

---

## Зависимости

### Обязательные зависимости

Без этих пакетов система не будет работать:

- `linux`, `linux-firmware` - ядро
- `base`, `base-devel` - базовая система
- `grub`, `efibootmgr` - загрузчик
- `networkmanager` - сеть
- `hyprland` - compositor
- `noctalia-shell-git` - shell

### Опциональные зависимости

Можно не устанавливать:

- Gaming стек (если не геймер)
- Development tools (если не разработчик)
- Bluetooth (если не используется)
- Printer support (если нет принтера)

---

## Конфликты пакетов

### Известные конфликты

**1. AUR helpers**
- Не устанавливать одновременно: `yay` и `paru` (конфликтуют)
- VV OS использует `paru` как основной

**2. Audio servers**
- Не устанавливать одновременно: `pulseaudio` и `pipewire`
- VV OS использует `pipewire`

**3. Display managers**
- Не включать одновременно несколько DM сервисов
- VV OS использует `sddm`

---

## Размер установки

**Приблизительные размеры:**

| Категория | Размер |
|-----------|--------|
| Base system | ~2 GB |
| Desktop (Hyprland + Noctalia) | ~1 GB |
| Gaming stack | ~5-10 GB (зависит от Wine/Proton версий) |
| Development tools | ~3-5 GB |
| Multimedia | ~500 MB |
| **Итого:** | **~15-20 GB** |

**Рекомендация:** 50 GB минимум (для системы + игры + кэш пакетов)

---

**Последнее обновление:** 2025-12-26
