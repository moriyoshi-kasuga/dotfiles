#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && pwd)
. "${script_root}"/common.sh
require_password

setup_start "Neovim"
echo

load_brew
if type "nvim" >/dev/null 2>&1; then
	install_exist "Neovim"
	brew upgrade neovim >/dev/null 2>&1
else
	install_start "Neovim"
	brew install neovim >/dev/null 2>&1
	install_end "Neovim"
fi

echo

if test -d ~/.config/nvim; then
	install_exist "Neovim"
	info ""
	echo "    Neovim を install (reinstall) したいときは"
	echo "    rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim ~/.cache/nvim && make neovim"
	echo "    を実行してください"
else
	install_start "Neovim"
	__ln ${PWD}/dotfiles/lazyvim ${HOME}/.config/nvim
	install_end "Neovim"
fi

echo
setup_end "Neovim"
