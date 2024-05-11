is_mac=$(uname -s | grep -qi "darwin" && echo true || echo false)
if "${is_mac}"; then
    source "${HOME}/zsh/darwin.zsh"
else
    source "${HOME}/zsh/linux.zsh"
fi

if [ -f "$HOME/.cargo/env" ] ; then
    source "$HOME/.cargo/env"
fi
