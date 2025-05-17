#!/usr/bin/env bash

script_root=$(cd "$(dirname "$0")" && cd .. && pwd)
. "${script_root}/common.sh"

setup_start "node"
echo

if type "volta" >/dev/null 2>&1; then
  install_exist "node"
else
  curl https://get.volta.sh | bash -s -- --skip-setup

  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"

  volta install node
fi

echo
setup_end "node"
