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
just apply nixos   # NixOS
just apply darwin  # macOS
just apply flake   # Home Manager only
just update        # flake update
```

初回実行で入力したコマンド種別とユーザー名は `.cachenix` に保存されます。
次回以降は `just apply` のみで前回値を再利用します。

## License

[MIT](./LICENSE)
