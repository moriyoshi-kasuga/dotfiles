#!/bin/bash

help() {
  echo "Usage: $0 [command]"
  echo "Commands:"
  echo "  create   Create a new Lima instance"
  echo "  build  Build the nix configuration in the Lima instance"
  echo "  help     Show this help message"
}

create() {
  if ! command -v lima &>/dev/null; then
    echo 'Lima is not installed or not in PATH'
    echo 'Please install Lima first.'
    exit 1
  fi

  echo 'Creating Lima instance...'
  limactl create --name nix ./lima.yaml
  SUCCESS=$?

  if [ $SUCCESS -ne 0 ]; then
    echo 'Failed to create Lima instance.'
    exit $SUCCESS
  fi

  echo 'Lima instance created successfully.'
}

_nix-build() {
  if ! command -v nix &>/dev/null; then
    echo 'Nix is not installed or not in PATH'
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
    echo 'Nix is now installed. Please run this script again.'
    exit 1
  fi
  USERNAME=$(nix --extra-experimental-features 'nix-command' eval --raw --file ./vars.nix username)
  OVERRIDE="{ homeDirectory = \"/home/${USERNAME}.linux\"; system = \"aarch64-linux\"; }"
  ./init.sh "$OVERRIDE"
}

build() {
  if [ ! -f "./vars.nix" ]; then
    echo 'vars.nix not found, please copy from vars.nix.example and edit it to your needs.'
    exit 1
  fi

  SHELL_COMMANDS=$(type _nix-build | awk 'NR > 3 { print $0 }' | sed '$d')
  limactl shell nix -- bash -cl "$SHELL_COMMANDS"
}

if [ $# -eq 0 ]; then
  help
  exit 0
fi

case $1 in
create)
  create
  ;;
build)
  build
  ;;
help)
  help
  ;;
*)
  echo "Unknown command: $1"
  help
  exit 1
  ;;
esac
