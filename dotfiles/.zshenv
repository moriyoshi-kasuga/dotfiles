case ${OSTYPE} in
  darwin*)
    source "${HOME}/zsh/darwin.zsh"
  ;;
  linux*)
    source "${HOME}/zsh/linux.zsh"
  ;;
esac

export XDG_CONFIG_HOME="$HOME/.config"

source "$HOME/.cargo/env"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
