#!/bin/bash

if ! command -v nix &>/dev/null; then
  echo 'Nix is not installed or not in PATH'
  echo 'If you not have Nix installed, goto https://nixos.org/download.html'
  exit 1
fi

if [ ! -f "./vars.nix" ]; then
  echo 'vars.nix not found, please copy from vars.nix.example. and edit it to your needs.'
  exit 1
fi

USERNAME=$(nix --extra-experimental-features 'nix-command' eval --raw --file ./vars.nix username)

if [ -z "$USERNAME" ]; then
  echo 'Username not set in vars.nix, please edit it to your needs.'
  exit 1
fi

VARS=$(nix --extra-experimental-features 'nix-command' eval --file ./vars.nix)

if [ -n "$1" ]; then
  VARS=$(nix --extra-experimental-features 'nix-command' eval --expr "$VARS // $1")
fi

VARS=$(nix --extra-experimental-features 'nix-command' eval --json --expr "$VARS")

echo 'Building Nix configuration...'
USER_NIX_VARS=$VARS nix --extra-experimental-features 'nix-command flakes' run --impure home-manager/master -- switch --impure --extra-experimental-features 'nix-command flakes' --flake .#"$USERNAME" --impure
SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
  echo 'Failed to apply Nix configuration.'
  exit $SUCCESS
fi
echo 'Backing up existing configuration files...'
