# bindkey emac
bindkey -e

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

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"

	if [ -f $HOME/.cache/chpwd-recent-dirs ]; then
		cat $HOME/.cache/chpwd-recent-dirs \
  			| sed -e 's/^..\(.*\)./\1/g' \
  			| while read line
		do
  			if [ -d "$line" ]; then
    			echo "\$'$line'" >>"$HOME/.cache/chpwd-recent-dirs.tmp"
  			fi
		done
		mv "$HOME/.cache/chpwd-recent-dirs.tmp" "$HOME/.cache/chpwd-recent-dirs"
	fi
fi

## export
export TERM=xterm-256color
export PATH=$PATH:/Library/PostgreSQL/15/bin
export EDITOR=vim
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'

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

