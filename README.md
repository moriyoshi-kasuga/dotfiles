# Dotfiles

macOS / NixOS 向けの Nix Flakes + Home Manager 構成です。

## Prerequisites

- [Nix](https://nixos.org/download.html)
- git

## Setup

```sh
git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## Apply

```sh
./init.sh nixos   # NixOS
./init.sh darwin  # macOS
./init.sh flake   # Home Manager only
./init.sh update  # flake update
```

## License

[MIT](./LICENSE)
