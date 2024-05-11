#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && cd .. && pwd)
. "${script_root}/common.sh"
require_password

setup_start "python"
echo

load_brew
if brew list --versions python >/dev/null; then
	install_exist "python"
	brew upgrade python >/dev/null 2>&1
else
	install_start "python"
	brew install python >/dev/null 2>&1
	install_end "python"
fi

echo
setup_end "python"
