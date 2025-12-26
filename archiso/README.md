# VV OS archiso Profile

Этот профиль archiso позволяет собрать собственный ISO образ VV OS с автоматическим запуском installer.

## Структура

```
archiso/
├── profiledef.sh          # Конфигурация профиля ISO
├── packages.x86_64        # Пакеты для Live ISO
├── pacman.conf            # Настройки pacman
├── build.sh               # Скрипт сборки ISO
├── airootfs/              # Файловая система ISO
│   ├── root/
│   │   ├── .bash_profile  # Auto-start installer
│   │   └── install-vv-os.sh
│   └── etc/systemd/system/
│       └── getty@tty1.service.d/
│           └── autologin.conf
└── out/                   # Собранный ISO (после сборки)
```

## Требования

- **ОС:** Arch Linux
- **Пакеты:** `archiso` (устанавливается автоматически через build.sh)
- **Диск:** ~10 GB свободного места
- **RAM:** 4 GB+

## Сборка ISO

### Автоматическая сборка

```bash
cd archiso
sudo ./build.sh
```

### Ручная сборка

```bash
# Установка archiso
sudo pacman -S archiso

# Копирование vv-os в airootfs
rm -rf airootfs/root/vv-os
cp -r ../ airootfs/root/vv-os/
rm -rf airootfs/root/vv-os/{archiso,.git}

# Сборка
sudo mkarchiso -v -w /tmp/archiso-tmp -o ./out .
```

## После сборки

ISO будет находиться в `archiso/out/vv-os-YYYY.MM.DD-x86_64.iso`

### Запись на USB

```bash
sudo dd if=out/vv-os-*.iso of=/dev/sdX bs=4M status=progress && sync
```

Замените `/dev/sdX` на ваше USB устройство.

### Тестирование в QEMU

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 2 \
  -cdrom out/vv-os-*.iso \
  -boot d
```

## Что происходит при загрузке

1. ISO загружается в Live режиме
2. Автоматический вход root на tty1
3. Автоматический запуск vv-live-installer.sh
4. Интерактивная установка VV OS

## Кастомизация

### Изменение списка пакетов

Отредактируйте `packages.x86_64`

### Добавление файлов в ISO

Поместите файлы в `airootfs/` - они будут скопированы в корень ISO

### Изменение boot меню

Отредактируйте файлы в `syslinux/` (BIOS) и `efiboot/` (UEFI)

---

**Примечание:** Сборка ISO требует sudo прав и займет 10-15 минут на обычном компьютере.
