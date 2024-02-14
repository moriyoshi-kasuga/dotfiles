#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
dotfiles_root=$(dirname "${script_root}")
. "${script_root}"/common.sh

setup_start "likes"
echo

install_start "likes"

pip3 install online-judge-tools >/dev/null 2>&1
npm install -g atcoder-cli >/dev/null 2>&1
npm install -g chokidar-cli >/dev/null 2>&1
__ln "${dotfiles_root}/dotfiles/acc/cpp" "$(acc config-dir)"
acc config default-template cpp >/dev/null 2>&1
acc config default-task-choice all >/dev/null 2>&1

install_end "likes"

echo
setup_end "likes"
