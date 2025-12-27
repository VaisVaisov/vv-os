#!/bin/bash
# Выбор языка установки

# Определяем язык по умолчанию из системной локали
DEFAULT_LANG="${LANG:0:2}"

# Если язык не русский и не английский - используем английский
if [[ "$DEFAULT_LANG" != "ru" && "$DEFAULT_LANG" != "en" ]]; then
  DEFAULT_LANG="en"
fi

# Даём пользователю выбрать язык
if command -v gum &>/dev/null; then
  echo "Choose installation language / Выберите язык установки:"
  echo ""

  SELECTED_LANG=$(gum choose "English" "Русский" --header "Language / Язык")

  case "$SELECTED_LANG" in
    "English")
      VV_LANG="en"
      ;;
    "Русский")
      VV_LANG="ru"
      ;;
    *)
      VV_LANG="$DEFAULT_LANG"
      ;;
  esac
else
  # Если gum не доступен, используем дефолтный язык
  VV_LANG="$DEFAULT_LANG"
fi

# Экспортируем переменную языка
export VV_LANG

# Загружаем файл локализации
if [[ -f "$VV_LANG/${VV_LANG}.sh" ]]; then
  source "$VV_LANG/${VV_LANG}.sh"
else
  # Fallback на английский если файл не найден
  source "$VV_LANG/en.sh"
fi

# Показываем приветствие
clear
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║           ██╗   ██╗██╗   ██╗     ██████╗ ███████╗            ║
║           ██║   ██║██║   ██║    ██╔═══██╗██╔════╝            ║
║           ██║   ██║██║   ██║    ██║   ██║███████╗            ║
║           ╚██╗ ██╔╝╚██╗ ██╔╝    ██║   ██║╚════██║            ║
║            ╚████╔╝  ╚████╔╝     ╚██████╔╝███████║            ║
║             ╚═══╝    ╚═══╝       ╚═════╝ ╚══════╝            ║
║                                                              ║
EOF

echo "║            $MSG_WELCOME"
echo "║                                                              ║"
echo "║           $MSG_ARCH_HYPRLAND             ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
