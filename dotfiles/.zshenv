case ${OSTYPE} in
  darwin*)
    source "${HOME}/zsh/darwin.zsh"
  ;;
  linux*)
    source "${HOME}/zsh/linux.zsh"
  ;;
esac

export XDG_CONFIG_HOME="$HOME/.config"

if [ -e "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi
