#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && pwd)
. "${script_root}"/common.sh
require_password

setup_start "likes"
echo

install_start "likes"

npm install -g chokidar-cli >/dev/null 2>&1

install_end "likes"

echo
setup_end "likes"
