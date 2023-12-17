#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh

setup_start "Docker"
echo

if type "docker" >/dev/null 2>&1; then
	install_exist "Docker"
else
	install_start "Docker"
	if "${is_mac}"; then
		load_brew
		brew install --cask docker
	else
		curl -fsSL https://get.docker.com -o get-docker.sh
		sudo sh get-docker.sh
		rm get-docker.sh
		sudo usermod -aG docker "$USER"
		sudo apt-get install -y docker-compose-plugin
	fi
	install_end "Docker"
fi

echo
setup_end "Docker"
