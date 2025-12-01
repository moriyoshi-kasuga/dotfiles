# Skip some initialization for non-interactive shells
[[ $- != *i* ]] && return

bindkey "^H" backward-delete-char

# Defer expensive zstyle configurations
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Defer edit-command-line setup
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line
