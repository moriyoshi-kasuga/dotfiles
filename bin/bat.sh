#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && pwd)
dotfiles_root=$(dirname "${script_root}")
. "${script_root}"/common.sh

if ! type "bat" >/dev/null 2>&1; then
    error "bat is not installed"
    exit
fi

if test -d "$(bat --config-dir)/themes"; then
    install_exist "bat themes"
    exit
fi

if test -d "$(bat --config-dir)/config"; then
    install_exist "bat themes"
    exit
fi

mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes" || exit
# Replace _night in the lines below with _day, _moon, or _storm if needed.
curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build
bat --list-themes | grep tokyo # should output "tokyonight_night"
echo '--theme="tokyonight_night"' >>"$(bat --config-dir)/config"
