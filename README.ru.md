# VV OS

<div align="center">

![Version](https://img.shields.io/github/v/release/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=E91E63&logo=github&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-E91E63?style=for-the-badge&labelColor=0C0D11)
![Stars](https://img.shields.io/github/stars/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=E91E63&logo=github&logoColor=white)
![Forks](https://img.shields.io/github/forks/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=00BCD4&logo=github&logoColor=white)
![Issues](https://img.shields.io/github/issues/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=E91E63&logo=github&logoColor=white)
![Last Commit](https://img.shields.io/github/last-commit/vaisvaisov/vv-os?style=for-the-badge&labelColor=0C0D11&color=00BCD4&logo=git&logoColor=white)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white&labelColor=0C0D11)

**Дистрибутив Arch Linux в стиле киберпанк**

*Hyprland + Noctalia Shell + игровой стек*

[Установка](#установка) • [Возможности](#возможности) • [Планы](#планы-развития) • [Системные требования](#системные-требования)

**[🇬🇧 English version](README.md)**

</div>

---

> **⚠️ Проект заархивирован**
> Разработка VV OS остановлена. Проблема, которую он решал — сложная настройка Arch Linux с готовым к играм десктопом — для нас больше не актуальна. Код остаётся здесь как референс; форкайте и делайте что хотите.

---

## Что такое VV OS?

**VV OS** — это кастомный дистрибутив Arch Linux, созданный для фанатов киберпанка и геймеров. Он объединяет передовые технологии Wayland (композитор Hyprland + Noctalia Shell) с полным игровым стеком и автоматической Material Design 3 темизацией.

Загрузитесь в полноценное GUI окружение прямо с ISO — попробуйте перед установкой!

### Почему VV OS?

- 🎮 **Готов к играм**: GameMode, Steam, Lutris, Wine/Proton настроены из коробки
- 🎨 **Красиво**: Material Design 3 с автогенерацией цветов из обоев
- 🚀 **Современно**: Последний Hyprland на Wayland с плавными анимациями
- 🔧 **Оптимизирован для NVIDIA**: Полная поддержка с игровыми твиками
- 💎 **Киберпанк эстетика**: CyberGRUB → Plymouth → SDDM с киберпанк темами
- 🖥️ **Live GUI**: Полноценное рабочее окружение в Live ISO — терминал не нужен

---

## Установка

### Способ 1: Скачать ISO (рекомендуется)

**Качайте последний ISO из [Releases](https://github.com/vaisvaisov/vv-os/releases)**

1. **Запишите на USB** (рекомендуется 8 ГБ+):
   ```bash
   # Linux
   sudo dd if=vv-os-*.iso of=/dev/sdX bs=4M status=progress && sync

   # Или используйте Rufus (Windows) / Etcher (кроссплатформенный)
   ```

2. **Загрузитесь с USB**: Выберите USB в меню загрузки BIOS/UEFI

3. **Попробуйте или установите**:
   - **Сначала попробуйте**: Загружается в Hyprland с автовходом — изучите систему!
   - **Готовы установить?**: Запустите "Install VV OS" из Noctalia Launcher(кнопка с ракетой слева сверху или SUPER+Space) или выполните:
     ```bash
     sudo vv-live-installer.sh
     ```

4. **Следуйте TUI установщику**: Выберите диск, создайте пользователя, настройте систему

5. **Перезагрузитесь** и наслаждайтесь новым рабочим столом в киберпанк-стиле!

### Способ 2: Собрать свой ISO

Хотите кастомизировать перед установкой? Соберите сами:

```bash
git clone https://github.com/vaisvaisov/vv-os.git
cd vv-os/archiso
sudo ./build.sh
# Результат: archiso/out/vv-os-YYYY.MM.DD-x86_64.iso
```

Затем следуйте Способу 1 с вашим кастомным ISO.

---

## Подключение к сети

**Нужен интернет для установки?** VV OS Live ISO предоставляет три способа подключения:

### Вариант 1: Noctalia Shell GUI (проще всего)

**Для пользователей графического интерфейса:**

1. Нажмите на **иконку сети** в правом верхнем углу Noctalia Shell
2. **Wi-Fi**: Выберите вашу сеть → введите пароль → Подключиться
3. **Ethernet**: Подключается автоматически при подключении кабеля

### Вариант 2: nmtui (терминальный интерфейс)

**Для любителей TUI:**

```bash
# Запустить Network Manager TUI
nmtui
```

**Настройка Wi-Fi:**
1. Выберите **"Activate a connection"** (Активировать подключение)
2. Выберите вашу Wi-Fi сеть
3. Введите пароль при запросе
4. Нажмите **Enter** для подключения

**Ethernet**: Подключается автоматически при подключении кабеля (настройка не требуется)

### Вариант 3: nmcli (командная строка)

**Для опытных пользователей CLI:**

**Wi-Fi:**
```bash
# Сканировать доступные сети
nmcli device wifi list

# Подключиться к Wi-Fi
nmcli device wifi connect "SSID" password "ваш_пароль"

# Проверить статус подключения
nmcli connection show
```

**Ethernet:**
```bash
# Проверить статус (должно подключиться автоматически)
nmcli device status

# Подключение вручную, если требуется
nmcli connection up "Wired connection 1"
```

**Проверка подключения к интернету:**
```bash
ping -c 3 archlinux.org
```

---

## Системные требования

### Минимальные характеристики

- **Процессор**: x86_64 (64-бит)
- **RAM**: 8 ГБ (16 ГБ для игр)
- **Диск**: Минимум 32 ГБ (SSD настоятельно рекомендуется)
- **Видеокарта**: См. таблицу ниже

### Статус поддержки GPU

| Тип GPU         | Desktop | Игры | Драйверы         | GameMode | Статус            |
| --------------- | ------- | ---- | ---------------- | -------- | ----------------- |
| **NVIDIA dGPU** | ✅       | ✅    | nvidia-open-dkms | ✅        | Полная поддержка  |
| **Intel iGPU**  | ✅       | ⚠️    | mesa             | ❌        | Базовая поддержка |
| **AMD dGPU**    | ⚠️       | ❌    | -                | ❌        | В планах          |
| **AMD APU**     | ⚠️       | ❌    | -                | ❌        | В планах          |

**Примечание**: Рабочий стол работает на Intel/AMD, но игровые оптимизации пока только для NVIDIA. Поддержка AMD в планах — [контрибьюторы приветствуются](#contributing)!

---

## Возможности

### Рабочее окружение

- **Композитор**: Hyprland (Wayland) с плавными анимациями
- **Оболочка**: Noctalia Shell (Qt6/QML) — красиво и функционально
- **Темизация**: Material Design 3 цвета автогенерируются из обоев через `matugen`
- **Загрузка**: CyberGRUB-2077 → Plymouth Cybernetic → SDDM Astronaut (киберпанк тема)

### Предустановленные приложения

#### Инструменты разработки
- **Редактор**: Neovim с конфигом LazyVim
- **Терминал**: Foot + Zsh + Oh-My-Zsh + Powerlevel10k
- **Git**: Git, Lazygit (TUI-клиент)
- **Контейнеры**: Docker, Lazydocker (TUI-клиент)

#### Игровой стек
- **Лаунчеры**: Steam, Lutris, XMCL (Minecraft)
- **Производительность**: GameMode, prime-launcher (NVIDIA)
- **Совместимость**: Wine, Proton, Steam Tinker Launch
- **Оверлеи**: MangoHud, GOverlay

#### Повседневное использование
- **Файлы**: Nemo
- **Браузер**: Chromium
- **Медиа**: Celluloid (видео), Strawberry (музыка)
- **Архивы**: PeaZip
- **Мониторинг**: neohtop
- **Питание**: TLP с автонастройками

### Кастомные скрипты

Запускайте из терминала:

- `vv-package-manager` — TUI для пакетов pacman/AUR
- `vv-pacman-search` — Поиск в официальных репозиториях
- `vv-aur-search` — Поиск в AUR
- `vv-flatpak-search` — Поиск/установка Flatpak приложений
- `vv-webapp-install` — Установка веб-приложений как PWA
- `vv-tui-install` — Установка TUI приложений
- `update-mirrors.sh` — Обновление зеркал через rate-mirrors

---

## После установки

### Первая загрузка

1. **Вход**: SDDM сразу приведёт вас в Hyprland
2. **Подождите 1-2 минуты**: Первый запуск генерирует Material 3 темы из обоев

### Быстрая настройка

- **Сменить обои**: Нажмите кнопку с совой справа сверху → Control Center → Wallpaper
  *(Цвета регенерируются автоматически!)*
- **Настроить мониторы**: Отредактируйте `~/.config/hypr/monitor.conf`
- **Обновить систему**: Выполните `sudo pacman -Syu`

### Горячие клавиши

**Приложения**:
- `Super + Return` → Терминал
- `Super + F` → Файловый менеджер
- `Super + B` → Браузер
- `Super + N` → Neovim
- `Super + T` → Системный монитор

**Окна**:
- `Super + Q` → Закрыть окно
- `Super + V` → Переключить плавающий режим
- `Super + Shift + F` → Полный экран
- `Super + 1-9` → Переключить рабочее пространство
- `Alt + Tab` → Переключение между окнами

Полный список в `~/.config/hypr/apps.conf` и `~/.config/hypr/tiling.conf`

---

## Решение проблем

### Чёрный экран после входа (NVIDIA)

1. Нажмите `Ctrl+Alt+F2` для переключения в TTY2
2. Войдите с вашим логином/паролем
3. Проверьте логи: `journalctl -xeu nvidia-persistenced`
4. Переустановите драйверы: `sudo pacman -S nvidia-open-dkms nvidia-utils`
5. Перезагрузитесь: `sudo reboot`

### WiFi не подключается

Noctalia Shell должна обработать это автоматически. Если нет:

```bash
sudo systemctl enable --now NetworkManager
nmtui  # Подключитесь через TUI
```

### Низкий FPS в играх (NVIDIA)

Используйте `prime-launcher` для принудительного использования дискретной видеокарты:

1. Откройте Steam
2. ПКМ на игре → Свойства → Параметры запуска
3. Добавьте: `prime-launcher %command%`

---

## Планы развития

### v1.1.x: Кастомный GUI установщик
- Красивый графический установщик с киберпанк темой (Python + PySide6)
- Выбор пакетов с чекбоксами
- Мультиязычность
- "Попробуй перед установкой" live окружение

### v2.0.0: Крупное обновление - VV OS для Android
- Кастомная прошивка на базе LineageOS с киберпанк эстетикой
- Игровые оптимизации для мобильных устройств
- Синхронизация Desktop ↔ Android через **VV Connect**
- Превращаем старые телефоны в ретро-игровые консоли

#### VV Connect - Синхронизация Desktop ↔ Android

Полноценный аналог [KDE Connect](https://kdeconnect.kde.org/) для экосистемы VV OS с киберпанк UI. Бесшовное подключение между VV OS Desktop и Android устройствами:

- **Синхронизация буфера**: Скопировал на телефоне → вставил на ПК (с синхронизацией cliphist истории)
- **Передача файлов**: Обмен файлами между устройствами с киберпанк UI
- **Уведомления**: Уведомления Android появляются на Desktop
- **Управление медиа**: Управляй RetroArch/музыкой на ПК с телефона
- **Удаленный ввод**: Используй телефон как тачпад/клавиатуру
- **SMS интеграция**: Отправка SMS с Desktop
- **Монитор батареи**: Показ заряда телефона на ПК
- **Синхронизация тем**: Material 3 темы синхронизируются между устройствами (выбрал обои → применилось везде)
- **Синхронизация конфигов**: Синхронизация конфигураций между Desktop и Android

Альтернативное название: **VV Sync**

### Будущие планы

- **Поддержка AMD GPU**: Драйверы AMD dGPU, конфиг GameMode, оптимизации APU (нужно железо для тестов)
- **Игровые оптимизации Intel iGPU**: Настройки для встроенной графики Intel
- **VV ROM Manager**: Загрузчик ROM для RetroArch с интеграцией Myrient API
- **OTA обновления**: Кастомный pacman репозиторий для обновления конфигов

---

## Известные проблемы (v1.0.3)

- **AMD GPU/APU**: Пока не поддерживаются (нужны драйверы + тестирование)
- **Intel iGPU**: Рабочий стол работает, но игровых оптимизаций пока нет

---

## Contributing

Помогите сделать VV OS лучше! Особенно нужны:

- **Владельцы AMD железа**: Тестируйте и помогайте реализовать поддержку AMD GPU/APU
- **Владельцы Intel GPU**: Тестируйте игровую производительность и помогайте оптимизировать
- **Переводчики**: Добавляйте новые языки (сейчас EN/RU)
- **Тестеры**: Пробуйте VV OS на разных конфигурациях железа

### Как помочь

1. Форкните репозиторий
2. Создайте ветку: `git checkout -b feature/cool-feature`
3. Закоммитьте: `git commit -m 'Add cool feature'`
4. Запушьте: `git push origin feature/cool-feature`
5. Откройте Pull Request

---

## Лицензия

**MIT License** — Copyright © 2025-2026 Vais Vaisov

Свободное использование, модификация и распространение в коммерческих и приватных целях.

### Сторонние компоненты

Некоторые темы используют GPL лицензии (Plymouth, SDDM). Они устанавливаются как отдельные пакеты и не влияют на лицензию VV OS установщика.

---

## Благодарности

- **Вдохновлено**: [Omarchy](https://github.com/basecamp/omarchy)
- **Рабочий стол**: [Hyprland](https://hyprland.org/) + [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)
- **Темы**: [CyberGRUB-2077](https://github.com/adnksharp/CyberGRUB-2077) • [Plymouth Cybernetic](https://github.com/adi1090x/plymouth-themes) • [SDDM Astronaut](https://github.com/Keyitdev/sddm-astronaut-theme)

---

## Контакты

- **GitHub**: [@vaisvaisov](https://github.com/vaisvaisov)
- **Issues**: [Сообщить об ошибке или запросить фичу](https://github.com/vaisvaisov/vv-os/issues)

---

<div align="center">

**Сделано с ❤️ для Linux сообщества**

*VV OS — Arch Linux для энтузиастов киберпанка*

</div>
