#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false

if "${is_mac}"; then
	error "This can only be called on mac"
	exit 1
fi

script_root=$(dirname "$(readlink -f "${0}")")
. "${script_root}"/common.sh
require_password

setup_start "linux"

npm install -g wsl-open
sudo ln -s "$(which wsl-open)" /usr/local/bin/open
sudo ln -s "$(which wsl-open)" /usr/local/bin/xdg-open

setup_end "linux"
