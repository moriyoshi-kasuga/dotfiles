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

### git の個人設定

`user.name` / `user.email` などマシンごとの git 設定はリポジトリに含めず、`~/.config/git/local` に書きます。
git の設定がこのファイルを include しており、ファイルが無ければ読み飛ばされます。

```gitconfig
[user]
	name = Your Name
	email = you@example.com
```

## Apply

初回は `init.sh` で適用します。nh を flake.lock の nixpkgs から借りて動かします。

```sh
./init.sh <name>    # <name> は Hosts の Name
```

一度適用すると [nh](https://github.com/nix-community/nh) が入り、`NH_FLAKE` にこのリポジトリとホストが設定されます。
以降はどのディレクトリからでも nh を使います。古い世代の掃除も nh が週 1 回行います。

```sh
nh os switch        # NixOS (--ask で差分を確認してから適用)
nh os boot          # NixOS, 次回起動時に適用
nh darwin switch    # macOS
nh os switch -u     # flake update してから適用
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
| **Font**       | Maple Mono Normal NL NF (既定、`style.fonts.monospace` で変更)   |

## Module Hierarchy

このリポジトリは [dendritic pattern](https://github.com/mightyiam/dendritic) を採用しています。
`modules/` と `hosts/` 以下のすべての `.nix` ファイルは [flake-parts](https://flake.parts) モジュールで、
[import-tree](https://github.com/vic/import-tree) が再帰的に import します

### 層

各ファイルは `flake.modules.<nixos|darwin>.<層>` に設定を書き足します。層は次の 2 つです。

| 層     | 対象             | 内容                                                                          |
| :----- | :--------------- | :---------------------------------------------------------------------------- |
| `base` | 全ホスト         | nix 設定、ユーザー、shell、editor、開発ツール、tailscale など                 |
| `pc`   | 画面を持つホスト | `base` に加えて terminal、font、壁紙、デスクトップ環境 (NixOS) / macOS の設定 |

home 側の設定は次の 2 通りで入れます。

- 全ホスト共通のものは `flake.modules.homeManager.base` に書きます。`modules/home-manager.nix` が `nixos.base` / `darwin.base` から primaryUser に入れます。
- 層や OS で絞るものは `flake.modules.<nixos|darwin>.<層>.people.home.imports` から入れます。

ホストは `nixos.pc` / `nixos.base` / `darwin.pc` のどれか 1 つを import するだけで、home 側の設定も揃います。

層に含めない任意の機能は、名前付きのモジュールとしてホストが個別に選びます。

- homeManager: `lang.buf` / `lang.c` / `lang.go` / `lang.haskell` / `lang.jvm` / `lang.lua` / `lang.node` / `lang.python` / `lang.rust` / `lang.wasm`（`people.home.imports` で選ぶ）
- nixos: `amd` / `nvidia` / `claude-desktop` / `game` / `server`
- darwin: `ios-dev`

### ディレクトリ

ディレクトリは OS ではなく機能ごとに分けています。どの OS 向けかは、ファイル内で書き足している class で分かります。
OS 固有の home 設定も `homeManager.*` の中で OS を判定せず、`nixos.*` / `darwin.*` から `people.home.imports` で入れます。
ただし `lang.*` は両 OS のホストが `people.home.imports` で選ぶ home 専用のモジュールなので、中で OS を判定します。

- `modules/`
  - `home-manager.nix`: home-manager の統合と層の配線
  - `users.nix`: `people.primaryUser` / `people.home`
  - `state-version.nix`: stateVersion
  - `nix/`: nix の設定、nixpkgs、nh
  - `style/`: Catppuccin、フォント、壁紙ローテーション
  - `shell/`: Fish / Starship / direnv / fzf / zoxide / nix-index と comma (zsh は system 側で有効にするだけ)、OS 差を埋める shim (`notify` / `pbcopy` など)
  - `editor/`: Neovim / Vim
  - `terminal/`: WezTerm
  - `lang/`: 各言語のツールチェインと language server
  - `dev/`: Git / tmux / Docker / Claude Code / CLI ツール / ドキュメント作成ツール / 開発用サービスの CLI / TaggedFileFlow / 開発用共有ライブラリ
  - `desktop/`: デスクトップ環境 (Niri + Noctalia / greetd / PipeWire / Bluetooth / Qt / fcitx5 / game など、NixOS) と GUI アプリ (Brave / Discord は macOS では Homebrew cask)
  - `macos/`: Homebrew / Aerospace / Dock / Finder / キーボード / iOS 開発ツール
  - `networking/`: NetworkManager・DNS、Tailscale
  - `system/`: ブートローダー・sudo・SSH・zram・タイムゾーンとロケール・SMART / fwupd・ドキュメント・基本パッケージ、`server`
  - `hardware/`: AMD / NVIDIA GPU、周辺機器
  - `flake/`: flake-parts 自体の設定（lint / eval check・formatter・devShell）
- `hosts/<name>/`: ホストごとの `nixosConfigurations` / `darwinConfigurations`

## License

[MIT](./LICENSE)
