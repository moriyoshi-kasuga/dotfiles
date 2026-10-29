#!/usr/bin/env bash

# 初回の適用用。nh はまだ入っていないので flake.lock の nixpkgs から借りて動かす。
# 一度適用すれば NH_FLAKE が設定されるので、以降は nh を直接使う。

set -euo pipefail

if [ $# -lt 1 ]; then
  echo 'Usage: ./init.sh <name> [nh options]'
  exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
  echo 'Nix is not installed or not in PATH.'
  echo 'Install: https://nixos.org/download.html'
  exit 1
fi

name=$1
shift

case "$(uname -s)" in
Linux) target=os ;;
Darwin) target=darwin ;;
*)
  echo "Unsupported OS: $(uname -s)"
  exit 1
  ;;
esac

cd "$(dirname "$0")"
exec nix --extra-experimental-features 'nix-command flakes' \
  run --inputs-from . nixpkgs#nh -- "${target}" switch ".#${name}" "$@"
