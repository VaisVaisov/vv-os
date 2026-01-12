# VV OS Architecture

Архитектура VV OS - подробное описание процесса сборки ISO и установки системы.

---

## Обзор

VV OS состоит из двух основных компонентов:

1. **ISO Builder** (`archiso/build.sh`) - сборка Live ISO с GUI
2. **System Installer** (`vv-live-installer.sh` + `install.sh`) - установка системы

### ISO Builder Process

```
┌─────────────────────────────────────┐
│   archiso/build.sh                  │
│   - Очистка старых файлов           │
│   - Сборка AUR пакетов              │
│   - Создание локального репозитория │
│   - Патч SDDM темы (cyberpunk)      │
│   - Сборка ISO через mkarchiso      │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│   vv-os-YYYY.MM.DD-x86_64.iso       │
│   - GUI Live environment            │
│   - Hyprland + Noctalia Shell       │
│   - SDDM с автологином              │
│   - Установщик в /root/vv-os/       │
└─────────────────────────────────────┘
```

### System Installation Process

VV OS использует **двухэтапную установку**:

1. **Этап 1:** `vv-live-installer.sh` - wrapper для archinstall (базовая система)
2. **Этап 2:** `install.sh` - установка VV OS компонентов в chroot

---

## Поток установки

```
┌─────────────────────────────────────┐
│   Arch Linux Live ISO               │
│   (загрузка с USB/ISO)              │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│   vv-live-installer.sh              │
│   - Выбор диска (gum menu)          │
│   - Запуск archinstall              │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│   archinstall                       │
│   - Разметка диска                  │
│   - Установка базовой системы       │
│   - Настройка GRUB                  │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│   vv-live-installer.sh              │
│   - Копирование VV OS в /mnt/tmp/   │
│   - arch-chroot /mnt                │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│   install.sh (в chroot)             │
│   - Определение языка               │
│   - Загрузка lang файлов            │
│   - Запуск модулей install/*.sh     │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│   Модули установки                  │
│   - 01-packages.sh                  │
│   - 02-configs.sh                   │
│   - 03-systemd.sh                   │
│   - 04-user.sh                      │
│   - 05-grub.sh (CyberGRUB)          │
│   - 06-plymouth.sh                  │
│   - 07-sddm.sh                      │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│   Перезагрузка                      │
│   - CyberGRUB bootloader            │
│   - Plymouth boot animation         │
│   - SDDM login screen               │
│   - Hyprland + Noctalia Shell       │
└─────────────────────────────────────┘
```

---

## Компоненты

### 1. vv-live-installer.sh

**Путь:** `/workspaces/vv-os/vv-live-installer.sh`

**Назначение:** Wrapper для запуска из Arch Live ISO. Упрощает процесс установки для пользователя.

**Основные функции:**

```bash
# Выбор диска для установки (интерактивно через gum)
select_disk() {
    # Показывает список доступных дисков
    # Пользователь выбирает один диск
    # Возвращает путь к диску (например, /dev/sda)
}

# Запуск archinstall с выбранным диском
run_archinstall() {
    # Передаёт диск в archinstall
    # archinstall устанавливает базовую систему
}

# Копирование VV OS в chroot среду
copy_vv_os_to_chroot() {
    # Копирует весь проект VV OS в /mnt/tmp/vv-os/
    # Устанавливает права доступа
}

# Запуск install.sh в chroot
install_vv_os_chroot() {
    # arch-chroot /mnt
    # cd /tmp/vv-os && ./install.sh
}
```

**Переменные:**

| Переменная | Значение | Описание |
|------------|----------|----------|
| `VV_BUILDER_PATH` | `/tmp/vv-os` | Путь к VV OS в chroot |
| `SELECTED_DISK` | `/dev/sdX` | Выбранный пользователем диск |

**Зависимости:**
- `gum` - интерактивные меню
- `archinstall` - установщик Arch Linux
- `rsync` - копирование файлов

---

### 2. install.sh

**Путь:** `/workspaces/vv-os/install.sh`

**Назначение:** Главный скрипт установки VV OS компонентов. Запускается в chroot после archinstall.

**Основные функции:**

```bash
# Определение языка системы
detect_language() {
    # Проверяет $LANG
    # Если ru_RU* - выбирает ru
    # Иначе - выбирает en (fallback)
}

# Загрузка локализации
load_language() {
    # source "lang/${LANG}.sh"
    # Загружает MSG_* переменные
}

# Последовательный запуск модулей
run_modules() {
    # Для каждого файла в install/*.sh (сортировка по имени)
    # source "install/${module}.sh"
    # Логирование прогресса
}
```

**Переменные:**

| Переменная | Значение | Описание |
|------------|----------|----------|
| `LANG` | `en` / `ru` | Язык интерфейса установщика |
| `INSTALL_LOG` | `/var/log/vv-os-install.log` | Лог установки |

**Зависимости:**
- Модули из `install/*.sh`
- Lang файлы из `lang/*.sh`

---

### 3. Модули установки (install/)

Каждый модуль отвечает за конкретную часть установки. Модули запускаются последовательно (по алфавиту имён файлов).

#### 01-packages.sh

**Назначение:** Установка всех пакетов из `packages/*.txt`

**Процесс:**
1. Обновление pacman баз данных (`pacman -Syy`)
2. Установка official repo пакетов (`pacman -S --noconfirm`)
3. Установка AUR helper (paru)
4. Установка AUR пакетов (`paru -S --noconfirm`)

**Списки пакетов:**
- `packages/base.txt` - базовые системные пакеты
- `packages/desktop.txt` - Hyprland, Noctalia Shell, Qt6
- `packages/gaming.txt` - GameMode, Lutris, Wine, Steam
- `packages/development.txt` - Git, Docker, Neovim
- `packages/theming.txt` - Material 3, GTK темы, иконки

#### 02-configs.sh

**Назначение:** Копирование конфигурационных файлов

**Процесс:**
1. Копирование системных конфигов в `/etc/`
2. Копирование пользовательских конфигов в `/home/$USER/.config/`
3. Копирование dotfiles (`.zshrc`, `.p10k.zsh`, etc.)
4. Установка прав доступа

**Структура:**
```
configs/
├── hypr/          → ~/.config/hypr/
├── noctalia/      → ~/.config/noctalia/
├── matugen/       → ~/.config/matugen/
├── foot/          → ~/.config/foot/
└── ...
```

#### 03-systemd.sh

**Назначение:** Настройка systemd сервисов и таймеров

**Процесс:**
1. Включение базовых сервисов:
   - `NetworkManager.service`
   - `bluetooth.service`
   - `sddm.service`
2. Включение user сервисов:
   - `noctalia.service` (Noctalia Shell autostart)
3. Включение таймеров:
   - `update-mirrors.timer` (обновление pacman зеркал)

#### 04-user.sh

**Назначение:** Создание пользователя и настройка групп

**Процесс:**
1. Создание пользователя (если не существует)
2. Добавление в группы:
   - `wheel` (sudo)
   - `docker` (Docker без sudo)
   - `video` (GPU access)
   - `input` (устройства ввода)
3. Настройка sudo (разрешить wheel без пароля - опционально)

#### 05-grub.sh

**Назначение:** Установка CyberGRUB-2077 темы

**Процесс:**
1. Клонирование CyberGRUB-2077 из GitHub
2. Копирование темы в `/boot/grub/themes/`
3. Обновление `/etc/default/grub`:
   ```bash
   GRUB_THEME="/boot/grub/themes/CyberGRUB-2077/theme.txt"
   ```
4. Регенерация GRUB конфига (`grub-mkconfig -o /boot/grub/grub.cfg`)

**Зависимости:**
- `git` (для клонирования)
- `grub` (уже установлен archinstall)

#### 06-plymouth.sh

**Назначение:** Установка Plymouth boot screen (тема Cybernetic)

**Процесс:**
1. Установка `plymouth`, `plymouth-themes-adi1090x-git`
2. Выбор темы:
   ```bash
   plymouth-set-default-theme -R cybernetic
   ```
3. Обновление `/etc/mkinitcpio.conf`:
   ```bash
   HOOKS=(... plymouth ...)
   ```
4. Регенерация initramfs (`mkinitcpio -P`)

#### 07-sddm.sh

**Назначение:** Установка SDDM display manager (тема astronaut)

**Процесс:**
1. Установка `sddm`, `qt6-svg` (зависимость для тем)
2. Клонирование темы astronaut
3. Копирование темы в `/usr/share/sddm/themes/`
4. Настройка `/etc/sddm.conf`:
   ```ini
   [Theme]
   Current=astronaut
   ```

---

## Многоязычность

### Система lang файлов

VV OS поддерживает несколько языков через систему переменных `MSG_*`.

**Структура:**
```
lang/
├── en.sh    # MSG_WELCOME="Welcome to VV OS installer"
└── ru.sh    # MSG_WELCOME="Добро пожаловать в установщик VV OS"
```

**Использование:**

```bash
# В install.sh
detect_language() {
    case "$LANG" in
        ru_RU*) LANG="ru" ;;
        *)      LANG="en" ;;
    esac
}

source "lang/${LANG}.sh"

echo "${MSG_WELCOME}"
echo "${MSG_INSTALLING_PACKAGES}"
```

**Переменные:**

| Переменная | Описание |
|------------|----------|
| `MSG_WELCOME` | Приветственное сообщение |
| `MSG_INSTALLING_PACKAGES` | Сообщение при установке пакетов |
| `MSG_COPYING_CONFIGS` | Сообщение при копировании конфигов |
| `MSG_DONE` | Сообщение о завершении |

---

## GPU Detection (планируется)

В будущем планируется автоматическое определение GPU и conditional установка драйверов.

**Архитектура:**

```bash
# Определение GPU
detect_gpu() {
    GPU_VENDOR=$(lspci | grep -i 'vga\|3d' | grep -ioE 'nvidia|amd|intel' | head -1)

    case "$GPU_VENDOR" in
        nvidia) install_nvidia_drivers ;;
        amd)    install_amd_drivers ;;
        intel)  install_intel_drivers ;;
        *)      echo "Unknown GPU, installing mesa fallback" ;;
    esac
}

# NVIDIA
install_nvidia_drivers() {
    pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils
    # Копирование NVIDIA-специфичных конфигов
    cp configs/hypr/env-nvidia.conf ~/.config/hypr/env.conf
}

# AMD
install_amd_drivers() {
    pacman -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
    # Копирование AMD-специфичных конфигов
    cp configs/hypr/env-amd.conf ~/.config/hypr/env.conf
}

# Intel
install_intel_drivers() {
    pacman -S --noconfirm mesa lib32-mesa vulkan-intel
    # Копирование Intel-специфичных конфигов
    cp configs/hypr/env-intel.conf ~/.config/hypr/env.conf
}
```

**Статус:** 📋 В планах (требуется тестирование на AMD/Intel hardware)

---

## Логирование

Все действия установщика логируются для диагностики.

**Файл лога:** `/var/log/vv-os-install.log`

**Формат:**
```
[2025-12-26 14:30:15] [INFO] Starting VV OS installation
[2025-12-26 14:30:16] [INFO] Language: ru
[2025-12-26 14:30:20] [INFO] Installing packages from packages/base.txt
[2025-12-26 14:35:42] [INFO] Copying configs to /home/user/.config/
[2025-12-26 14:36:10] [ERROR] Failed to copy file: configs/hypr/monitor.conf
[2025-12-26 14:45:00] [INFO] VV OS installation completed successfully
```

**Уровни:**
- `INFO` - информационные сообщения
- `WARNING` - предупреждения (не критичные)
- `ERROR` - ошибки (критичные)

---

## Обработка ошибок

Каждый модуль должен корректно обрабатывать ошибки.

**Best practices:**

```bash
# Проверка успешности команды
if ! pacman -S --noconfirm package; then
    log "ERROR" "Failed to install package"
    exit 1
fi

# Проверка существования файла
if [ ! -f "configs/file.conf" ]; then
    log "WARNING" "Config file not found, using default"
    # fallback
fi

# Безопасное копирование
cp -f source dest || {
    log "ERROR" "Failed to copy source to dest"
    exit 1
}
```

---

## Тестирование

### Unit тестирование (будущее)

Планируется добавить unit тесты для каждого модуля.

**Структура:**
```
tests/
├── test-01-packages.sh
├── test-02-configs.sh
└── ...
```

### Integration тестирование

Тестирование в VM (VMWare/VirtualBox).

**Процесс:**
1. Загрузить Arch Live ISO в VM
2. Запустить `vv-live-installer.sh`
3. Проверить успешность установки
4. Проверить работоспособность системы после перезагрузки

---

**Последнее обновление:** 2025-12-26
