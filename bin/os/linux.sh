#!/usr/bin/env bash

is_mac=$(uname -s | grep -qi "darwin" && echo true || echo false)

if "${is_mac}"; then
	error "This can only be called on mac"
	exit 1
fi

script_root=$(cd "$(dirname "$0")" && cd .. && pwd)
. "${script_root}"/common.sh
require_password

setup_start "linux"

npm install -g wsl-open
sudo ln -s "$(which wsl-open)" /usr/local/bin/open
sudo ln -s "$(which wsl-open)" /usr/local/bin/xdg-open

setup_end "linux"
