# ## Complement
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

setopt no_beep

## History
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=1000            # メモリに保存されるヒストリの件数
SAVEHIST=1000            # 保存されるヒストリの件数
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_ignore_space
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

## export
export TERM=xterm-256color
export PATH=$PATH:/Library/PostgreSQL/15/bin
export EDITOR=vim

if [ -d "./local.zsh" ] ; then
    source "./local.zsh"
fi

function fzf-cdr () {
    local selected_dir="$(cdr -l | awk '{ print $2 }' | sed 's/^[0-9]\+ \+//' | fzf --reverse --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}

zle -N fzf-cdr
zvm_after_init_commands+=('bindkey "^G" fzf-cdr')
