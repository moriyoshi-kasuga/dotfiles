#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh

setup_start "coursier"
echo

if type "cs" >/dev/null 2>&1; then
	install_exist "coursier"
else
	install_start "coursier"
	if "${is_mac}"; then
		curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d >cs
		chmod +x cs
		sudo mv cs /usr/local/bin/
	else
		brew install coursier/formulas/coursier >/dev/null 2>&1
	fi
	yes n | cs setup
    cs install metals
	install_end "coursier"
fi

echo
setup_end "coursier"
