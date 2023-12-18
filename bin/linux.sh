#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false

if "${is_mac}"; then
	error "This can only be called on linux"
	exit 1
fi

script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh
require_password

setup_start "Linux"

sudo apt install xdg-utils >/dev/null 2>&1; then
sudo add-apt-repository ppa:wslutilities/wslu >/dev/null 2>&1; then
sudo apt update >/dev/null 2>&1; then
sudo apt install wslu >/dev/null 2>&1; then

setup_end "Linux"
