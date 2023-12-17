#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh

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
