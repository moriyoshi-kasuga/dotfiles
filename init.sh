#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./init.sh <command> [name] [options]

Commands:
  nixos <name> [--boot]   Apply NixOS configuration
  darwin <name>           Apply nix-darwin configuration
  update                  Update flake inputs
  help                    Show this help message
EOF
}

require_nix() {
  if ! command -v nix >/dev/null 2>&1; then
    echo 'Nix is not installed or not in PATH.'
    echo 'Install: https://nixos.org/download.html'
    exit 1
  fi
}

run_flake_update() {
  echo 'Updating Nix configuration...'
  nix --extra-experimental-features 'nix-command flakes' flake update
  echo 'Nix configuration updated.'
}

run_darwin() {
  local name=$1
  sudo -H nix --extra-experimental-features 'nix-command flakes' \
    run nix-darwin/master#darwin-rebuild -- \
    switch --flake .#"${name}"
}

run_nixos() {
  local name=$1
  local extra=${2-}

  if [ -z "${extra}" ]; then
    sudo -H nixos-rebuild switch --flake .#"${name}"
  elif [ "${extra}" == "--boot" ]; then
    sudo -H nixos-rebuild boot --flake .#"${name}"
  else
    echo "Unknown argument for nixos: ${extra}"
    echo 'Usage: ./init.sh nixos <name> [--boot]'
    exit 1
  fi
}

main() {
  local command=${1-}
  if [ -z "${command}" ]; then
    echo 'No command provided.'
    usage
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
  nixos | darwin)
    require_nix
    ;;
  *)
    echo "Unknown command: ${command}"
    usage
    exit 1
    ;;
  esac

  local name=${2-}
  if [ -z "${name}" ]; then
    echo 'name is required.'
    usage
    exit 1
  fi

  echo "Building Nix configuration...: ${name}"

  case "${command}" in
  darwin)
    run_darwin "${name}"
    ;;
  nixos)
    run_nixos "${name}" "${3-}"
    ;;
  esac
}

main "$@"
