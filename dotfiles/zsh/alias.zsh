### alias

# ls
alias l='eza --color=always --icons=always'
alias ll='eza --color=always --long --git --icons=always'
alias la='eza --color=always --icons=always --all'
alias lsa='eza --all --color=always --long --git --icons=always'
alias lt='eza --color=always --tree --git --icons=always --git-ignore'

# Directory
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

# Dockerコマンド
alias d='docker'
alias dc='docker compose'
alias dcps='docker compose ps'
alias dcud='docker compose up -d'
alias dcudb='docker compose up -d --build'
alias dce='docker compose exec'
alias dcl='docker compose logs'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcbnc='docker compose build --no-cache'
alias dl='lazydocker'

# git
alias ga="git add"
alias gbd="git branch -d"
alias gb='git branch'
alias gcm='git commit -m'
alias gca="git commit --amend"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gl="git log --date=iso --decorate"
alias glp="git log --date=iso --decorate --patch"
alias glg="git log --date=iso --graph --decorate --oneline --all"
alias gs="git status"
alias gf="git fetch"
alias gp="git pull"
alias gst="git stash"
alias gstl="git stash list"
alias gstp="git stash pop"
alias gstd="git stash drop"

# useful
alias lg="lazygit"
alias v="nvim"
alias e="exit"
alias c="clear"
alias reload="exec zsh -l"

# atcoder with rust
alias acc="cargo compete"
alias acct="cargo compete test"
alias accs="cargo compete submit"
alias acco="cargo compete open"
