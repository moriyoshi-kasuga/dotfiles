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

### vars.nix (必須)

`vars.nix` はビルドに必須です。`vars.nix.example` を参考に作成してください。

```sh
cp vars.nix.example vars.nix
# 内容を編集する
```

`vars.nix` は `git.includes` などの個人設定を保持し、フレークの `vars-file` input として外部注入されます。
リポジトリには **コミットしないでください**（`.gitignore` 済み）。

## Apply

```sh
./init.sh nixos   <name>   # NixOS
./init.sh darwin  <name>   # macOS
./init.sh flake   <name>   # Home Manager only
./init.sh update           # flake update
```

## Hosts

| Name | OS | 用途 |
| :--- | :--- | :--- |
| `desktop` | NixOS (x86_64) | メインデスクトップ (GUI) |
| `sv-main` | NixOS (x86_64) | サーバー (GUI なし) |
| `laptop` | macOS (aarch64) | ノートPC |
| `job` | macOS (aarch64) | 仕事用 |

## Environment

| Component | Software |
| :--- | :--- |
| **Compositor** | [Niri](https://github.com/niri-wm/niri) (Scrolling Compositor) |
| **Shell UI** | [Noctalia-shell](https://github.com/noctalia-dev/noctalia-shell) |
| **Terminal** | [WezTerm](https://wezterm.org) |
| **Editor** | [Neovim](https://neovim.io) |
| **Shell** | [Fish](https://fishshell.com) |
| **Theme** | [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) |
| **Font** | Maple Mono Normal NL NF / JetBrains Mono Nerd Font |

## Module Hierarchy

```
modules/
├── common/               # クロスプラットフォーム共通
│   ├── base.nix          # Home Manager 基盤・Catppuccin
│   ├── shell/            # Fish / Zsh / Starship / direnv / fzf / zoxide
│   ├── editor/           # Neovim / Vim
│   ├── terminal/         # WezTerm
│   ├── lang/             # C / Node / Python / Go / Rust (+WASM) / Haskell / JVM / ...
│   ├── tool/             # Git / tmux / Docker / Claude Code / ripgrep / bat / mise / ...
│   ├── library.nix       # 開発用共有ライブラリ (LD_LIBRARY_PATH, PKG_CONFIG_PATH)
│   ├── font.nix          # JetBrains Mono NF / Maple Mono / Noto CJK
│   └── wallpaper.nix     # 壁紙ローテーション (systemd / launchd)
│
├── nixos/                # NixOS システム設定
│   ├── basic.nix         # ユーザー・sudo・SSH・Nix GC
│   ├── network.nix       # NetworkManager・ホスト名・DNS
│   ├── i18n.nix          # タイムゾーン・ロケール
│   ├── tailscale.nix     # Tailscale VPN
│   └── gui/              # GUI 環境 (nixos.gui.enable = true のみ有効化)
│       ├── basic.nix     # libinput・polkit・upower・電源管理
│       ├── niri.nix      # Niri compositor + Noctalia shell
│       ├── audio.nix     # PipeWire
│       ├── bluetooth.nix # Bluetooth
│       ├── sddm.nix      # ディスプレイマネージャー
│       └── ...           # Qt / Brave / game / thunar / zathura / i18n (fcitx5)
│
└── darwin/               # macOS システム設定
    ├── homebrew.nix      # Homebrew casks・iOS 開発ツール
    ├── aerospace.nix     # Aerospace ウィンドウマネージャー
    ├── dock.nix          # Dock 設定
    └── ...               # finder / tailscale
```

モジュールは `modules.<name>.enable = true` で個別有効化、または親モジュールの `enable = true` で一括有効化されます。
詳細は [`docs/architecture.md`](docs/architecture.md) を参照してください。

## License

[MIT](./LICENSE)
