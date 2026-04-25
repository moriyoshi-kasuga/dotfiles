# Dotfiles

macOS / NixOS 向けの Nix Flakes + Home Manager 構成です。

## Prerequisites

- [Nix](https://nixos.org/download.html)
- git

## Setup

`$HOME/dotfiles` にcloneすることを前提としています。

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

## Environment

| Component | Software |
| :--- | :--- |
| **Compositor** | [Niri](https://github.com/niri-wm/niri) (Scrolling Compositor) |
| **Shell UI** | [Noctalia-shell](https://github.com/noctalia-dev/noctalia-shell) |
| **Terminal** | [Wezterm](https://wezterm.org) |
| **Editor** | [Neovim](https://neovim.io) |
| **Theme** | [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) |
| **Fonts** | JetBrains Mono Nerd Font |

## Features

「Unixporn」風の美しさと機能性を両立した構成です。

- **統一されたテーマ**: すべてのコンポーネントで Catppuccin Mocha を採用。
- **徹底した透過設定**: Wezterm, Neovim, Tmux, Fzf 等、すべてのレイヤーで背景透過を適用。
- **高速な操作**: Niri のスクロール型レイアウトと、各ツールの親和性を高めたキーバインド。

## License

[MIT](./LICENSE)
