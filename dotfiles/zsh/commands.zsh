### Custom commands

source "${HOME}/zsh/script/user.sh"
source "${HOME}/zsh/script/venv.sh"

function fzf-history-selection() {
    local cmd=`history -n 1 | tac  | awk '!a[$0]++' | grep -v 'cd ' | fzf --reverse --prompt="history >" --query "$LBUFFER"`
    if [ -n "$cmd" ]; then
        BUFFER=$cmd
        zle reset-prompt
    fi
}

zle -N fzf-history-selection

function fzf-cdr () {
    local selected_dir="$(cdr -l | awk '{ print $2 }' | sed 's/^[0-9]\+ \+//' | fzf --reverse --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}

zle -N fzf-cdr

zvm_after_init_commands+=('bindkey "^R" fzf-history-selection')
zvm_after_init_commands+=('bindkey "^G" fzf-cdr')
