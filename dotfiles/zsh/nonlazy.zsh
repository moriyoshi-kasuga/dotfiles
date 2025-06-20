# bindkey emac
bindkey -e

bindkey "^H" backward-delete-char

# ## Complement
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # 補完時に大文字小文字を区別しない
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

setopt no_beep

## History
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=1000            # メモリに保存されるヒストリの件数
SAVEHIST=1000            # 保存されるヒストリの件数

setopt appendhistory
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt hist_find_no_dups

## export
export EDITOR=vim
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export MANPAGER='nvim +Man!'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

if [ -d "./local.zsh" ] ; then
    source "./local.zsh"
fi
