#!/bin/bash

set -euo pipefail

if ! command -v nix &>/dev/null; then
  echo 'Nix is not installed or not in PATH'
  echo 'If you not have Nix installed, goto https://nixos.org/download.html'
  exit 1
fi

if [ ! -f "./vars.nix" ]; then
  echo 'vars.nix not found, please copy from vars.nix.example. and edit it to your needs.'
  exit 1
fi

USERNAME=$(nix eval --raw --file ./vars.nix username)

if [ -z "$USERNAME" ]; then
  echo 'Username not set in vars.nix, please edit it to your needs.'
  exit 1
fi

echo 'Building Nix configuration...'
nix --extra-experimental-features 'nix-command flakes' run home-manager/master -- switch --flake .#"$USERNAME"
echo 'Backing up existing configuration files...'
