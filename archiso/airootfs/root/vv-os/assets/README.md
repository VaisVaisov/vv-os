# Assets для VV Builder

Графические ресурсы для установки системы.

## Структура

```
assets/
├── wallpapers/
│   └── wallpapers.zip (или распакованные PNG/JPG)
└── avatar/
    └── .face (аватар пользователя, PNG без расширения)
```

## Wallpapers

**Формат:** PNG, JPG, JPEG

**Варианты:**
1. **ZIP архив** - `wallpapers.zip`
   - Автоматически распакуется в `~/Pictures/Wallpapers/`
   - Требует пакет `unzip` (уже в списке)

2. **Распакованные файлы** - `*.png`, `*.jpg`
   - Скопируются напрямую в `~/Pictures/Wallpapers/`

**Установка:**
```bash
# При установке скрипт автоматически:
mkdir -p ~/Pictures/Wallpapers
unzip wallpapers.zip -d ~/Pictures/Wallpapers/  # если ZIP
# или
cp wallpapers/*.{png,jpg} ~/Pictures/Wallpapers/  # если распакованные
```

## Avatar (.face)

**Что это:** Аватар пользователя для display manager (SDDM, GDM)

**Формат:** PNG изображение **без расширения** (называется просто `.face`)

**Расположение после установки:**
- `~/.face` - основной файл (используется SDDM, Noctalia)
- `~/.face.icon` - симлинк на `.face` (совместимость)

**Установка:**
```bash
# При установке скрипт автоматически:
cp .face ~/.face
chmod 644 ~/.face
ln -sf ~/.face ~/.face.icon  # симлинк для совместимости
```

**Создание .face:**
```bash
# Если у тебя PNG с расширением:
cp avatar.png .face  # просто переименовать

# Конвертировать и ресайзить (256x256 рекомендуется):
convert avatar.png -resize 256x256 .face
```

---

**Обновлено:** 2025-12-26
