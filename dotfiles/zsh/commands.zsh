### Custom commands

source "${HOME}/zsh/function/common.zsh"
source "${HOME}/zsh/function/venv.zsh"
source "${HOME}/zsh/function/tmux.zsh"

function fzf-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | grep -v 'cd ' | fzf --reverse`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N fzf-history-selection
bindkey '^R' fzf-history-selection

function fzf-cdr () {
    local selected_dir="$(cdr -l | awk '{ print $2 }' | sed 's/^[0-9]\+ \+//' | fzf --reverse --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N fzf-cdr
bindkey '^G' fzf-cdr
