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

## export
export TERM=xterm-256color
export PATH=$PATH:/Library/PostgreSQL/15/bin
export EDITOR=vim

if [ -d "./local.zsh" ] ; then
    source "./local.zsh"
fi
