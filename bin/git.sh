#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && pwd)
dotfiles_root=$(dirname "${script_root}")
. "${script_root}"/common.sh
require_password

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
