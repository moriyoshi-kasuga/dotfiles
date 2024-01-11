#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh

setup_start "coursier"
echo

if "${is_mac}"; then
	load_brew
	if brew list --versions coursier; then
		install_exist "coursier"
		brew upgrade coursier/formulas/coursier >/dev/null 2>&1
	else
		install_start "coursier"
		brew install coursier/formulas/coursier >/dev/null 2>&1
        yes n | cs setup
		install_end "coursier"
	fi
else
	if type "cs" >/dev/null 2>&1; then
		install_exist "coursier"
	else
		install_start "coursier"
        curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs
		chmod +x cs
		sudo mv cs /usr/local/bin/
        yes n | cs setup
		install_end "coursier"
	fi
fi

echo
setup_end "coursier"
