case ${OSTYPE} in
  darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  linux*)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
esac

export PATH=$HOME/.nodebrew/current/bin:$PATH

export XDG_CONFIG_HOME="$HOME/.config"
