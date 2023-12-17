#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh

setup_start "Neovim (AstroNvim)"
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
	install_exist "Astronvim"
	info ""
	echo "    Astronvim を install (reinstall) したいときは"
	echo "    rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim ~/.cache/nvim && make astronvim"
	echo "    を実行してください"
else
	brew install luarocks >/dev/null 2>&1
	install_start "Astronvim"
	git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim >/dev/null 2>&1
	git clone --depth 1 https://github.com/moriyoshi-kasuga/astronvim_config.git ~/.config/nvim/lua/user >/dev/null 2>&1
	install_end "Astronvim"
fi

echo
setup_end "Neovim (AstroNvim)"
