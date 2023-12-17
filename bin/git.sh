#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
dotfiles_root=$(dirname "${script_root}")
. "${script_root}"/common.sh

setup_start "git"
echo

load_brew
if type "git" >/dev/null 2>&1; then
	install_exist "git"
	brew upgrade git >/dev/null 2>&1
else
	install_start "git"
	brew install git >/dev/null 2>&1
	install_end "git"
fi

root="${HOME}/.gitconfigs"
if [[ ! -d "${root}" ]]; then
	cp -r "${dotfiles_root}/dotfiles/.gitconfigs" "${root}"
	info "${root} にExample gitconfig を作成しました"
fi

echo
setup_end "git"
