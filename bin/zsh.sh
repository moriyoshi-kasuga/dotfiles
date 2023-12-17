#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
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

zsh_path="$(which zsh)"

if ! grep -q "$zsh_path" /etc/shells >/dev/null; then
	info "adding $zsh_path to /etc/shells"
	echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi

if test "$SHELL" != "$zsh_path"; then
	sudo chsh -s "$zsh_path" "$(whoami)" | zsh
	info "default shell changed to $zsh_path"
fi

echo
setup_end "zsh"
