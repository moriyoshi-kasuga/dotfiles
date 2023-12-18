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

sudo apt install xdg-utils

setup_end "Linux"
