# Material 3 Powerlevel10k Theme

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs prompt_char)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs virtualenv time)

  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#690000'
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='#ffb4a8'

  typeset -g POWERLEVEL9K_DIR_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#ffb4a8'
  # Убираем пробел после dir
  typeset -g POWERLEVEL9K_DIR_SUFFIX=''
  # Убираем разделитель справа от dir
  typeset -g POWERLEVEL9K_DIR_RIGHT_DELIMITER=''
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#ffb4a8'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#ffb4a8'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#ffb956'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#ffb4a8'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#ffb4a8'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND='#ffb4ab'

  # Убираем пробел между dir и prompt_char
  typeset -g POWERLEVEL9K_PROMPT_CHAR_PREFIX=''
  # Убираем разделитель слева от prompt_char
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_DELIMITER=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#ffb4a8'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#ffb4ab'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'

  # Иконка перед кодом ошибки
  typeset -g POWERLEVEL9K_STATUS_ICON_BEFORE_CONTENT=true
  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#ffb956'
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=none
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  # Отключаем специальное отображение сигналов (показываем числовой код)
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=false
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#ffb4ab'
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=none
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#ffb4a8'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#2f1a17'

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#ffb4a8'
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#ffb956'
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#ffb956'
  typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND='#2f1a17'

  typeset -g POWERLEVEL9K_TIME_FOREGROUND='#ffdad4'
  typeset -g POWERLEVEL9K_TIME_BACKGROUND='#2f1a17'
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${0:A}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
