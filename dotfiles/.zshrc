ZSH_DIR=${${(%):-%N}:A:h}/zsh
# source command override technique
function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[m $1"
    zcompile $1
  fi
}
ensure_zcompiled ~/.zshrc

source "$ZSH_DIR/alias.zsh"
source "$ZSH_DIR/nonlazy.zsh"

# sheldon cache technique
export SHELDON_CONFIG_DIR="$ZSH_DIR/sheldon"
sheldon_cache="${XDG_CACHE_HOME:-$HOME/.cache}/sheldon.zsh"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  mydir="${sheldon_cache%/*}"
  [[ -d $mydir ]] || mkdir -p "$mydir"
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml

zsh-defer source "$ZSH_DIR/lazy.zsh"
zsh-defer source "$ZSH_DIR/commands.zsh"
unfunction source

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && zsh-defer source "$HOME/.sdkman/bin/sdkman-init.sh"
