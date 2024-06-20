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

sudo add-apt-repository ppa:wslutilities/wslu -y
sudo apt update
sudo apt install -y wslu
sudo ln -s "$(which wslview)" /usr/local/bin/open
sudo ln -s "$(which wslview)" /usr/local/bin/xdg-open

setup_end "linux"
