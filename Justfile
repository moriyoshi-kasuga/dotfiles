set shell := ["bash", "-euo", "pipefail", "-c"]

cache_file := ".cachenix"

help:
    @just --list

_require_nix:
    @command -v nix >/dev/null 2>&1 || { echo 'Nix is not installed or not in PATH.'; echo 'Install: https://nixos.org/download.html'; exit 1; }

_write_cache command username:
    @printf 'command=%s\nusername=%s\n' '{{ command }}' '{{ username }}' > {{ cache_file }}

_run_flake username:
    @nix --extra-experimental-features 'nix-command flakes' run home-manager/master -- switch --extra-experimental-features 'nix-command flakes' --flake .#"{{ username }}" -b backup

_run_darwin username:
    @sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake .#"{{ username }}"

_run_nixos username:
    @sudo nixos-rebuild switch --flake .#"{{ username }}"

update: _require_nix
    @echo 'Updating Nix configuration...'
    @nix --extra-experimental-features 'nix-command flakes' flake update
    @echo 'Nix configuration updated.'

apply command="" username="": _require_nix
    @input_command='{{ command }}'; \
    input_username='{{ username }}'; \
    cache_command=''; \
    cache_username=''; \
    if [ -f {{ cache_file }} ]; then \
      . {{ cache_file }}; \
      cache_command="${command:-}"; \
      cache_username="${username:-}"; \
    fi; \
    final_command="${input_command:-${cache_command:-}}"; \
    if [ -z "${final_command}" ]; then \
      read -r -p "Please input command (flake/nixos/darwin): " final_command; \
    fi; \
    case "${final_command}" in \
      flake|nixos|darwin) ;; \
      *) echo "Unknown command: ${final_command}"; echo 'Use one of: flake, nixos, darwin'; exit 1 ;; \
    esac; \
    final_username="${input_username:-${cache_username:-}}"; \
    if [ -z "${final_username}" ]; then \
      read -r -p "Please input name: " final_username; \
    fi; \
    if [ -z "${final_username}" ]; then \
      echo 'Username is required.'; \
      exit 1; \
    fi; \
    just _write_cache "${final_command}" "${final_username}"; \
    echo "Building Nix configuration...: ${final_username}"; \
    case "${final_command}" in \
      flake) just _run_flake "${final_username}" ;; \
      darwin) just _run_darwin "${final_username}" ;; \
      nixos) just _run_nixos "${final_username}" ;; \
    esac
