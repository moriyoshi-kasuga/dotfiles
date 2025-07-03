### alias

# utilities
alias todo='vim ~/todo.txt'

# ls
alias l='eza'
alias ll='eza --long --git'
alias la='eza --all'
alias lsa='eza --all --long'
alias lt='eza --tree --git-ignore'

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
alias dcs='docker compose stop'
alias dcb='docker compose build'
alias dcbnc='docker compose build --no-cache'
alias dl='lazydocker'

# git
alias gbd="git branch -d"
alias gb='git branch'
alias gcm='git commit -m'
alias gc="git checkout"
alias gcb="git checkout -b"
alias gl="git log --date=iso --decorate"
alias gs="git status"

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
