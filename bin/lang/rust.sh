#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && cd .. && pwd)
. "${script_root}/common.sh"
require_password

setup_start "rust"
echo

if type "cargo" >/dev/null; then
	install_exist "rust"
else
	install_start "rust"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	source "$HOME/.cargo/env"
	rustup toolchain install stable
	rustup default stable
	install_end "rust"
fi

echo
setup_end "rust"
