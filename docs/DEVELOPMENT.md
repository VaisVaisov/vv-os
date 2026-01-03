# VV OS Development Guide

Руководство для разработчиков VV OS installer.

---

## Начало работы

### Требования

- **OS:** Arch Linux (или Arch-based)
- **Tools:** git, bash 5.0+, gum (для интерактивных меню)
- **Testing:** VMWare/VirtualBox, Arch Live ISO
- **GPU:** NVIDIA (для тестирования gaming стека)

### Клонирование проекта

```bash
git clone https://github.com/vaisvaisov/vv-os.git
cd vv-os
```

---

## Структура проекта

```
/workspaces/vv-os/vv-installer/
├── install/              # Модули установки (нумерованные)
├── packages/             # Списки пакетов по категориям
├── configs/              # Конфигурационные файлы
├── scripts/              # Пользовательские скрипты
├── assets/               # Ресурсы (обои, иконки)
├── lang/                 # Локализация (EN/RU)
├── docs/                 # Документация
├── install.sh            # Главный скрипт установки
├── vv-live-installer.sh  # Live ISO wrapper
├── logo.txt, icon.txt    # ASCII art
├── logo.svg, icon.svg    # Vector graphics
└── LICENSE               # MIT License
```

---

## Добавление нового модуля

### 1. Создание модуля

Модули хранятся в `install/` и запускаются **по алфавиту** имён файлов.

**Naming convention:** `NN-description.sh` (где NN - номер 01-99)

```bash
# Пример: создать модуль для установки fonts
nano install/08-fonts.sh
```

**Шаблон модуля:**

```bash
#!/bin/bash

# 08-fonts.sh - Установка шрифтов

echo "${MSG_INSTALLING_FONTS}"  # Используй переменные из lang/

# Установка пакетов
pacman -S --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts-emoji

# Копирование конфигов (если нужно)
cp -r configs/fonts/* /usr/share/fonts/

# Обновление кэша шрифтов
fc-cache -fv

echo "${MSG_FONTS_INSTALLED}"
```

### 2. Добавление локализации

Добавь переменные в `lang/en.sh` и `lang/ru.sh`:

**lang/en.sh:**
```bash
MSG_INSTALLING_FONTS="Installing fonts..."
MSG_FONTS_INSTALLED="Fonts installed successfully"
```

**lang/ru.sh:**
```bash
MSG_INSTALLING_FONTS="Установка шрифтов..."
MSG_FONTS_INSTALLED="Шрифты успешно установлены"
```

### 3. Тестирование модуля

```bash
# В chroot среде
arch-chroot /mnt
cd /tmp/vv-os

# Запустить только один модуль
bash install/08-fonts.sh

# Или полную установку
./install.sh
```

---

## Добавление пакетов

Пакеты хранятся в `packages/*.txt` по категориям.

### Структура файла пакетов

```
# Комментарии начинаются с #
# Один пакет на строку
# Пустые строки игнорируются

# Desktop Environment
hyprland
noctalia-shell-git
quickshell-git

# Fonts
ttf-jetbrains-mono-nerd
ttf-font-awesome
```

### Категории пакетов

| Файл              | Описание                              |
| ----------------- | ------------------------------------- |
| `base.txt`        | Базовые системные пакеты              |
| `desktop.txt`     | DE (Hyprland, Noctalia, Qt6)          |
| `gaming.txt`      | Игровой стек (GameMode, Lutris, Wine) |
| `development.txt` | Dev tools (Git, Docker, Neovim)       |
| `theming.txt`     | Темы, иконки, шрифты                  |
| `multimedia.txt`  | Медиа приложения                      |
| `utilities.txt`   | Системные утилиты                     |

### Добавление нового пакета

```bash
# 1. Определить категорию
nano packages/gaming.txt

# 2. Добавить пакет в конец файла
echo "steam" >> packages/gaming.txt

# 3. Если это AUR пакет, добавь суффикс -git/-bin
echo "discord-canary-bin" >> packages/utilities.txt
```

**Important:** Модуль `01-packages.sh` автоматически различает official repo и AUR пакеты.

---

## Добавление конфигов

Конфиги хранятся в `configs/` и копируются модулем `02-configs.sh`.

### Структура конфигов

```
configs/
├── hypr/          # Hyprland конфиги → ~/.config/hypr/
├── noctalia/      # Noctalia Shell → ~/.config/noctalia/
├── foot/          # Terminal → ~/.config/foot/
├── dotfiles/      # Dotfiles → ~/
└── system/        # System configs → /etc/
```

### Добавление нового конфига

```bash
# 1. Создать директорию для приложения
mkdir -p configs/myapp

# 2. Скопировать конфиги
cp ~/.config/myapp/* configs/myapp/

# 3. (Опционально) Обновить 02-configs.sh
nano install/02-configs.sh

# Добавить копирование
cp -r configs/myapp ~/.config/
```

---

## Добавление пользовательских скриптов

Скрипты хранятся в `scripts/` и копируются в `~/.local/bin/`.

### Naming convention

- `vv-*` - префикс для всех VV OS скриптов
- Используй kebab-case: `vv-launch-webapp`

### Создание нового скрипта

```bash
# 1. Создать скрипт
nano scripts/vv-my-script

#!/bin/bash
# vv-my-script - Описание скрипта

echo "Hello from VV OS!"

# 2. Сделать исполняемым
chmod +x scripts/vv-my-script

# 3. Скрипт автоматически скопируется в ~/.local/bin/
#    при установке модулем 02-configs.sh
```

---

## Локализация (добавление нового языка)

VV OS поддерживает EN/RU. Добавить новый язык:

### 1. Создать lang файл

```bash
# Например, для немецкого
cp lang/en.sh lang/de.sh
nano lang/de.sh
```

### 2. Перевести все переменные

```bash
# lang/de.sh
MSG_WELCOME="Willkommen zum VV OS Installer"
MSG_INSTALLING_PACKAGES="Pakete werden installiert..."
# ... и так далее для всех MSG_* переменных
```

### 3. Обновить определение языка в install.sh

```bash
nano install.sh

detect_language() {
    case "$LANG" in
        ru_RU*) LANG="ru" ;;
        de_DE*) LANG="de" ;;  # Добавить немецкий
        *)      LANG="en" ;;
    esac
}
```

---

## Тестирование

### Unit тестирование (планируется)

```bash
# Будет добавлено в будущем
tests/
├── test-01-packages.sh
├── test-02-configs.sh
└── ...
```

### Integration тестирование в VM

**Процесс:**

1. Создать VM (VMWare/VirtualBox)
2. Загрузить Arch Live ISO
3. Скопировать VV OS на ISO (или клонировать из GitHub)
4. Запустить `./vv-live-installer.sh`
5. Проверить установку после перезагрузки

**Чеклист:**
- [ ] Arch Linux базовая система установлена
- [ ] Hyprland запускается
- [ ] Noctalia Shell работает
- [ ] Material 3 theming применяется
- [ ] GRUB тема загружается (CyberGRUB-2077)
- [ ] Plymouth boot screen показывается
- [ ] SDDM login screen работает
- [ ] Gaming стек функционален (GameMode, Wine, Steam)

---

## Git workflow

### Branching strategy

- `main` - стабильная версия
- `dev` - разработка
- `feature/*` - новые фичи
- `fix/*` - багфиксы

### Commit messages

```bash
# Формат
<type>: <subject>

# Примеры
feat: add AMD GPU support
fix: correct path in vv-live-installer.sh
docs: update DEVELOPMENT.md
refactor: restructure install modules
```

**Types:**
- `feat` - новая фича
- `fix` - багфикс
- `docs` - документация
- `refactor` - рефакторинг
- `test` - тесты
- `chore` - рутинные задачи

---

## Best Practices

### Bash скрипты

```bash
# 1. Всегда использовать shebang
#!/bin/bash

# 2. Использовать set для безопасности
set -euo pipefail  # Exit on error, undefined vars, pipe fails

# 3. Проверять зависимости
command -v gum >/dev/null 2>&1 || {
    echo "Error: gum is required"
    exit 1
}

# 4. Использовать переменные из lang/
echo "${MSG_INSTALLING_PACKAGES}"

# 5. Логировать важные действия
log "INFO" "Installing package: ${PACKAGE}"

# 6. Обрабатывать ошибки
if ! pacman -S package; then
    log "ERROR" "Failed to install package"
    exit 1
fi
```

### Конфигурационные файлы

- Всегда добавлять комментарии
- Использовать осмысленные имена
- Группировать связанные настройки
- Документировать нестандартные параметры

### Документация

- Обновлять CLAUDE.md при структурных изменениях
- Добавлять комментарии в сложных скриптах
- Документировать новые модули в ARCHITECTURE.md
- Обновлять PACKAGES.md при добавлении категорий

---

## Troubleshooting

### Частые проблемы

**1. Модуль не запускается**
```bash
# Проверить права доступа
chmod +x install/08-module.sh

# Проверить синтаксис
bash -n install/08-module.sh
```

**2. Пакет не устанавливается**
```bash
# Проверить название пакета
paru -Ss package-name

# Проверить категорию (official vs AUR)
pacman -Si package-name  # official
paru -Si package-name    # AUR
```

**3. Конфиг не копируется**
```bash
# Проверить пути в 02-configs.sh
# Убедиться что путь правильный
ls -la configs/myapp/
```

---

## Контрибьюция

### Как внести вклад

1. Fork проекта
2. Создать feature branch: `git checkout -b feature/amazing-feature`
3. Commit изменения: `git commit -m 'feat: add amazing feature'`
4. Push в branch: `git push origin feature/amazing-feature`
5. Создать Pull Request

### Guidelines

- Следовать существующему стилю кода
- Добавлять комментарии для сложной логики
- Обновлять документацию
- Тестировать изменения в VM
- Использовать осмысленные commit messages

---

## Полезные ссылки

- **GitHub Repository:** https://github.com/vaisvaisov/vv-os
- **Arch Linux Wiki:** https://wiki.archlinux.org/
- **Hyprland Wiki:** https://wiki.hypr.land/
- **Bash Guide:** https://mywiki.wooledge.org/BashGuide

---

**Последнее обновление:** 2025-12-26
