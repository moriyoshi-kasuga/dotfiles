#!/usr/bin/env bash

export TERM=xterm-256color

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh
require_password

# on_debug=true
on_debug=false

if "${on_debug}"; then
	make debug
	debug "exit debug"
	exit 0
fi

notice "${BLACK}${CYAN_BG}★ Start setup Initialize"

if ! "${is_mac}"; then
	sudo apt-get -y -qq update >/dev/null 2>&1
	sudo apt-get -y -qq upgrade >/dev/null 2>&1
	sudo apt-get -y -qq clean >/dev/null 2>&1
fi

make link

make brew

make zsh

make git

make node

make python

make coursier

make neovim

make docker

if "${is_mac}"; then
	make darwin
else
	make linux
fi

echo
notice "${BLACK}${CYAN_BG}◎ Initialize complete!. Please Terminal Reboot!."
