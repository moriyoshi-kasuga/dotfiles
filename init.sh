#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./init.sh <command>

Commands:
  flake    Apply Home Manager configuration
  nixos    Apply NixOS configuration
  darwin   Apply nix-darwin configuration
  update   Update flake inputs
  help     Show this help message
EOF
}

require_nix() {
  if ! command -v nix >/dev/null 2>&1; then
    echo 'Nix is not installed or not in PATH.'
    echo 'Install: https://nixos.org/download.html'
    exit 1
  fi
}

read_username() {
  local username
  read -r -p "Please input name: " username
  if [ -z "${username}" ]; then
    echo 'Username is required.'
    exit 1
  fi
  echo "${username}"
}

run_flake_update() {
  echo 'Updating Nix configuration...'
  nix --extra-experimental-features 'nix-command flakes' flake update
  echo 'Nix configuration updated.'
}

run_home_manager() {
  local username=$1
  nix --extra-experimental-features 'nix-command flakes' \
    run home-manager/master -- \
    switch --extra-experimental-features 'nix-command flakes' --flake .#"${username}" -b backup
}

run_darwin() {
  local username=$1
  sudo nix --extra-experimental-features 'nix-command flakes' \
    run nix-darwin/master#darwin-rebuild -- \
    switch --flake .#"${username}"
}

run_nixos() {
  local username=$1
  local extra=${2-}

  if [ -n "${extra}" ] && [ "${extra}" != "--upgrade" ]; then
    echo "Unknown argument for nixos: ${extra}"
    echo 'Usage: ./init.sh nixos [--upgrade]'
    exit 1
  fi

  if [ "${extra}" = "--upgrade" ]; then
    echo 'Upgrading NixOS system...'
  else
    echo 'Applying NixOS configuration...'
  fi

  # shellcheck disable=SC2068
  sudo nixos-rebuild switch --flake .#"${username}"
}

main() {
  local command=${1-}
  if [ -z "${command}" ]; then
    echo 'No command provided.'
    echo 'Use ./init.sh help to see available commands.'
    exit 1
  fi

  case "${command}" in
  help)
    usage
    exit 0
    ;;
  update)
    require_nix
    run_flake_update
    exit 0
    ;;
  flake | nixos | darwin)
    require_nix
    ;;
  *)
    echo "Unknown command: ${command}"
    echo 'Use ./init.sh help to see available commands.'
    exit 1
    ;;
  esac

  shift

  local username
  username=$(read_username)
  echo "Building Nix configuration...: ${username}"

  case "${command}" in
  flake)
    run_home_manager "${username}"
    ;;
  darwin)
    run_darwin "${username}"
    ;;
  nixos)
    run_nixos "${username}" "${1-}"
    ;;
  esac
}

main "$@"
