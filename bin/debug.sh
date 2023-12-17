#!/usr/bin/env bash

test "$(uname)" = "Darwin" && is_mac=true || is_mac=false
"${is_mac}" && script_root=$(dirname "$(readlink -f "${0}")") || script_root=$(dirname "$(realpath "$0")")
. "${script_root}"/common.sh
require_password

debug "shell = ${SHELL}"
