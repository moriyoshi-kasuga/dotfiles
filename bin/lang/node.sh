#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && cd .. && pwd)
. "${script_root}/common.sh"
require_password

setup_start "node"
echo

load_brew
if type "nodebrew" >/dev/null 2>&1; then
	install_exist "nodebrew"
	brew upgrade nodebrew >/dev/null 2>&1
else
	install_start "nodebrew"
	brew install nodebrew >/dev/null 2>&1
	install_end "nodebrew"
fi

if [[ ":$PATH:" != *":$HOME/.nodebrew/current/bin:"* ]]; then
	export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

nodebrew setup >/dev/null 2>&1
nodebrew install-binary latest >/dev/null 2>&1
nodebrew use latest

echo
setup_end "node"
