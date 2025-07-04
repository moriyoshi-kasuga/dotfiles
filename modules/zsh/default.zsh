bindkey "^H" backward-delete-char

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line

source "${HOME}/.zsh-scripts/user.sh"
source "${HOME}/.zsh-scripts/pyvenv.sh"
