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

| Name           | OS              | 用途                     |
| :------------- | :-------------- | :----------------------- |
| `desktop`      | NixOS (x86_64)  | メインデスクトップ (GUI) |
| `laptop-nixos` | NixOS (x86_64)  | ノートPC (NixOS, GUI)    |
| `sv-main`      | NixOS (x86_64)  | サーバー (GUI なし)      |
| `laptop-mac`   | macOS (aarch64) | ノートPC (macOS)         |
| `job`          | macOS (aarch64) | 仕事用                   |

## Environment

unixpornではなく、シンプルさを保つための設定です。

| Component      | Software                                                         |
| :------------- | :--------------------------------------------------------------- |
| **Compositor** | [Niri](https://github.com/niri-wm/niri) (Scrolling Compositor)   |
| **Shell UI**   | [Noctalia-shell](https://github.com/noctalia-dev/noctalia-shell) |
| **Terminal**   | [WezTerm](https://wezterm.org)                                   |
| **Editor**     | [Neovim](https://neovim.io)                                      |
| **Shell**      | [Fish](https://fishshell.com)                                    |
| **Theme**      | [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) |
| **Font**       | Maple Mono Normal NL NF                                          |

## Module Hierarchy

このリポジトリは [dendritic pattern](https://github.com/mightyiam/dendritic) を採用しています。
`modules/` と `hosts/` 以下のすべての `.nix` ファイルは [flake-parts](https://flake.parts) モジュールで、
[import-tree](https://github.com/vic/import-tree) が再帰的に import します

### 層

各ファイルは `flake.modules.<nixos|darwin|homeManager>.<層>` に設定を書き足します。層は次の 2 つです。

| 層     | 対象             | 内容                                                                          |
| :----- | :--------------- | :---------------------------------------------------------------------------- |
| `base` | 全ホスト         | nix 設定、ユーザー、shell、editor、開発ツール、tailscale など                 |
| `pc`   | 画面を持つホスト | `base` に加えて terminal、font、壁紙、デスクトップ環境 (NixOS) / macOS の設定 |

`modules/home-manager.nix` が OS 側の層と home 側の層をつないでいます。
ホストは `nixos.pc` / `nixos.base` / `darwin.pc` のどれか 1 つを import するだけで、home 側の設定も揃います。

層に含めない任意の機能は、名前付きのモジュールとしてホストが個別に選びます。

- homeManager: `lang.buf` / `lang.c` / `lang.go` / `lang.haskell` / `lang.jvm` / `lang.lua` / `lang.node` / `lang.python` / `lang.rust` / `lang.wasm`（`people.home.imports` で選ぶ）
- nixos: `amd` / `nvidia` / `claude-desktop` / `server`

### ディレクトリ

ディレクトリは OS ではなく機能ごとに分けています。どの OS 向けかは、ファイル内で書き足している class で分かります。

- `modules/`
  - `home-manager.nix`: home-manager の統合と層の配線
  - `users.nix`: `people.primaryUser` / `people.home`
  - `state-version.nix`: stateVersion
  - `nix/`: nix の設定、nixpkgs
  - `style/`: Catppuccin、フォント、壁紙ローテーション
  - `shell/`: Fish / Zsh / Starship / direnv / fzf / zoxide、OS 差を埋める shim (`notify` / `pbcopy` など)
  - `editor/`: Neovim / Vim
  - `terminal/`: WezTerm
  - `lang/`: 各言語のツールチェインと language server
  - `dev/`: Git / tmux / Docker / Claude Code / CLI ツール / 開発用共有ライブラリ
  - `desktop/`: Niri + Noctalia / greetd / PipeWire / Bluetooth / Qt / fcitx5 / Brave / game など (NixOS)
  - `macos/`: Homebrew / Aerospace / Dock / Finder / キーボード / iOS 開発ツール
  - `networking/`: NetworkManager・DNS、Tailscale
  - `system/`: ブートローダー・sudo・SSH・zram・タイムゾーンとロケール、`server`
  - `hardware/`: AMD / NVIDIA GPU、周辺機器
  - `flake/`: flake-parts 自体の設定（lint / eval check・formatter・devShell）
- `hosts/<name>/`: ホストごとの `nixosConfigurations` / `darwinConfigurations`

## License

[MIT](./LICENSE)
