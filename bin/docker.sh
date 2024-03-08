#!/usr/bin/env bash

is_mac=$(uname -s | grep -qi "darwin" && echo true || echo false)
script_root=$(cd "$(dirname "$0")" && pwd)
. "${script_root}"/common.sh
require_password

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
