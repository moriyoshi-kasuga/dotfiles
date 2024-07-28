autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function fzf-cdr () {
    local selected_dir="$(cdr -l | awk '{ print $2 }' | sed 's/^[0-9]\+ \+//' | fzf --reverse --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}

zle -N fzf-cdr
bindkey "^G" fzf-cdr

## bat
export BAT_THEME=tokyonight_moon

## fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

local preview='[ -d {} ] && eza --tree --color=always {} | head -200 || bat -n --color=always --line-range :500 {}'

export FZF_CTRL_R_OPTS="--reverse --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
export FZF_CTRL_T_OPTS="--preview '$preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=fg:#c8d3f5,bg:#222436,hl:#ff966c \
--color=fg+:#c8d3f5,bg+:#2f334d,hl+:#ff966c \
--color=info:#82aaff,prompt:#86e1fc,pointer:#86e1fc \
--color=marker:#c3e88d,spinner:#c3e88d,header:#c3e88d"

# for f in zvm_backward_kill_region zvm_yank zvm_change_surround_text_object zvm_vi_delete zvm_vi_change zvm_vi_change_eol; do
#   eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
#   eval "$f() { _$f; echo -en \$CUTBUFFER | pbcopy }"
# done
#
# for f in zvm_vi_replace_selection; do
#   eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
#   eval "$f() { CUTBUFFER=\$(pbpaste); _$f; echo -en \$CUTBUFFER | pbcopy }"
# done
#
# for f in zvm_vi_put_after zvm_vi_put_before; do
#   eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
#   eval "$f() { CUTBUFFER=\$(pbpaste); _$f; zvm_highlight clear }"
# done

bindkey "^H" backward-delete-char
