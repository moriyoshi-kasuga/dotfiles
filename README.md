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
./init.sh nixos   <name> [--boot]   # NixOS
./init.sh darwin  <name>            # macOS
./init.sh update                    # flake update
```

## Hosts

| Name | OS | 用途 |
| :--- | :--- | :--- |
| `desktop` | NixOS (x86_64) | メインデスクトップ (GUI) |
| `laptop-nixos` | NixOS (x86_64) | ノートPC (NixOS, GUI) |
| `sv-main` | NixOS (x86_64) | サーバー (GUI なし) |
| `laptop-mac` | macOS (aarch64) | ノートPC (macOS) |
| `job` | macOS (aarch64) | 仕事用 |

## Environment

unixpornではなく、シンプルさを保つための設定です。

| Component | Software |
| :--- | :--- |
| **Compositor** | [Niri](https://github.com/niri-wm/niri) (Scrolling Compositor) |
| **Shell UI** | [Noctalia-shell](https://github.com/noctalia-dev/noctalia-shell) |
| **Terminal** | [WezTerm](https://wezterm.org) |
| **Editor** | [Neovim](https://neovim.io) |
| **Shell** | [Fish](https://fishshell.com) |
| **Theme** | [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) |
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
│   └── gui/              # GUI 環境
│       ├── basic.nix     # libinput・polkit・upower・電源管理
│       ├── niri.nix      # Niri compositor + Noctalia shell
│       ├── audio.nix     # PipeWire
│       ├── bluetooth.nix # Bluetooth
│       ├── sddm.nix      # ディスプレイマネージャー
│       └── ...           # Qt / Brave / game / thunar / zathura / i18n (fcitx5)
│
└── darwin/               # macOS システム設定
    ├── homebrew.nix      # Homebrew casks
    ├── ios-dev.nix       # iOS 開発ツール (Xcode 関連)
    ├── aerospace.nix     # Aerospace ウィンドウマネージャー
    ├── dock.nix          # Dock 設定
    └── ...               # finder / tailscale

profiles/                 # ホストに割り当てる Home Manager profile の束ね
├── core.nix              # profile.core (shell / editor / tool の基本セット)
├── desktop.nix           # profile.desktop (GUI 込みのフルセット)
├── gui-common.nix        # profile.gui-common (WezTerm / wallpaper)
└── lang-full.nix         # profile.lang-full (全言語ツールチェイン)

hosts/                    # ホストごとの nixosConfigurations / darwinConfigurations
├── desktop/              # default.nix + hardware-configuration.nix
├── laptop-nixos/         # default.nix + hardware-configuration.nix
├── sv-main/              # default.nix + hardware-configuration.nix
├── laptop-mac/           # default.nix (macOS はハードウェア設定なし)
└── job/                  # default.nix
```

このリポジトリは [dendritic pattern](https://github.com/vic/import-tree) を採用しており、`modules/` と `profiles/` 以下のすべての
`.nix` ファイルは [flake-parts](https://flake.parts) モジュールです（`import-tree` が再帰的に import します）。各ファイルは
`flake.modules.<nixos|darwin|homeManager>.<aspect>` に自身を登録します。`hosts/<name>/default.nix` は使う aspect を明示的に
import して `nixosConfigurations` / `darwinConfigurations` を組み立てるホスト定義ファイルで、こちらも同様に import-tree の対象ですが、
`hardware-configuration.nix`（自動生成されるハードウェア設定）だけは flake-parts モジュールではないため import 対象から除外されています。

## License

[MIT](./LICENSE)
