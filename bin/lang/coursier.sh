#!/usr/bin/env bash

is_mac=$(uname -s | grep -qi "darwin" && echo true || echo false)
script_root=$(cd "$(dirname "$0")" && cd .. && pwd)
. "${script_root}/common.sh"
require_password

setup_start "coursier"
echo

if type "cs" >/dev/null 2>&1; then
	install_exist "coursier"
else
	install_start "coursier"
	if "${is_mac}"; then
		brew install coursier/formulas/coursier >/dev/null 2>&1
		yes n | coursier setup
		coursier install metals
	else
		curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d >cs
		chmod +x cs
		sudo mv cs /usr/local/bin/
		yes n | cs setup
		cs install metals
	fi
	install_end "coursier"
fi

echo
setup_end "coursier"
