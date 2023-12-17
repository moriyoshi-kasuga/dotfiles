#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
dotfiles_root=$(dirname "${script_root}")
. "${script_root}"/common.sh
require_password

setup_start "Homebrew"
echo

if type "brew" >/dev/null 2>&1; then
	install_exist "Homebrew"
	brew update >/dev/null 2>&1
else
	install_start "Homebrew"
	if ! "${is_mac}"; then
		sudo apt-get -y install build-essential procps curl file git >/dev/null 2>&1
	fi
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >/dev/null 2>&1
	load_brew
	install_end "Homebrew"
fi

echo
install_start "Brew bundle"

brew bundle --file="${dotfiles_root}"/config/Brew.Unix.Brewfile
brew bundle --file="${dotfiles_root}"/config/Brew."$(uname)".Brewfile

install_end "Brew bundle"

echo
setup_end "Homebrew"
