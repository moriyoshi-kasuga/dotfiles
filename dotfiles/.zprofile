case ${OSTYPE} in
    darwin*)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="$PATH:/Users/${USER}/Library/Application Support/Coursier/bin"
        ;;
    linux*)
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        export PATH="$PATH:/home/${USER}/.local/share/coursier/bin"
        ;;
esac

export PATH=$HOME/.nodebrew/current/bin:$PATH

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

export XDG_CONFIG_HOME="$HOME/.config"
