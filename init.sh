#!/usr/bin/env bash

# options: flake, update, darwin, help

OPTIONS=$1
case $OPTIONS in
flake) ;;
nixos) ;;
darwin) ;;
update)
  echo 'Updating Nix configuration...'
  nix --extra-experimental-features 'nix-command flakes' flake update
  echo 'Nix configuration updated.'
  exit 0
  ;;
help)
  echo 'Usage: ./init.sh [option]'
  echo 'Options:'
  echo '  flake    - Apply the Nix configuration using flakes'
  echo '  nixos    - Apply the Nix configuration on NixOS'
  echo '  update  - Update the Nix configuration'
  echo '  darwin  - Apply the Nix configuration on macOS'
  echo '  help    - Show this help message'
  exit 0
  ;;
*)
  if [ -z "$OPTIONS" ]; then
    echo 'No option provided.'
  else
    echo "Unknown option: $OPTIONS"
  fi
  echo 'Use ./init.sh help to see available options.'
  exit 1
  ;;
esac

shift

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

dir="$(dirname "$(realpath "$0")")/dotfiles"

VARS=$(nix --extra-experimental-features 'nix-command' eval --json --expr "$VARS // { dotfilesDir = $dir; }")

echo 'Building Nix configuration...'
case $OPTIONS in
flake)
  USER_NIX_VARS=$VARS nix --extra-experimental-features 'nix-command flakes' run --impure home-manager/master -- switch --impure --extra-experimental-features 'nix-command flakes' --flake .#"$USERNAME" --impure -b backup
  ;;
darwin)
  sudo env USER_NIX_VARS="$VARS" nix --extra-experimental-features 'nix-command flakes' run --impure nix-darwin/master#darwin-rebuild -- switch --impure --flake .#"$USERNAME" --impure
  ;;
nixos)
  if [ "$1" == "--upgrade" ]; then
    echo 'Upgrading NixOS system...'
  elif [ -z "$1" ]; then
    echo 'Applying NixOS configuration...'
  else
    echo "Unknown argument for nixos option: $1"
    echo 'Usage: ./init.sh nixos [--upgrade]'
    exit 1
  fi
  # shellcheck disable=SC2068
  sudo env USER_NIX_VARS="$VARS" nixos-rebuild switch --flake .#"$USERNAME" --impure $@
  ;;
*) ;;
esac

SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
  echo 'Failed to apply Nix configuration.'
  exit $SUCCESS
fi
echo 'Backing up existing configuration files...'
