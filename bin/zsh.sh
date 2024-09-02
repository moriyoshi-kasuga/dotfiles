#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && pwd)
. "${script_root}"/common.sh
require_password

setup_start "zsh"
echo

if type "zsh" >/dev/null 2>&1; then
    install_exist "zsh"
else
    install_start "zsh"

    load_brew
    brew install zsh >/dev/null 2>&1

    install_end "zsh"
fi

rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/sheldon.zsh"

if type "sheldon" >/dev/null 2>&1; then
    install_exist "sheldon"
else
    install_start "sheldon"

    load_brew
    brew install sheldon >/dev/null 2>&1

    install_end "sheldon"
fi

zsh_path="$(which zsh)"

if ! grep -q "$zsh_path" /etc/shells >/dev/null; then
    info "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi

if test "$SHELL" != "$zsh_path"; then
    sudo chsh -s "$zsh_path" "$(whoami)" | zsh
    info "default shell changed to $zsh_path"
fi

info "updating terminfo"
tempfile=$(mktemp) &&
    curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo &&
    tic -x -o ~/.terminfo $tempfile &&
    rm $tempfile

echo
setup_end "zsh"
