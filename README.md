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

ホストを足すときは `hosts/<name>/default.nix` を作り、設定の名前と `people.flakeHost` を `<name>` にそろえます。
nh はこの名前で設定を選ぶので、ずれていると `nix flake check` が落ちます。
hardware configuration は `_` で始まる名前にして、import-tree に読ませません。

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
名前は定義しているファイルの名前 (ディレクトリならその名前) で、`modules/lang/` の下のものには `lang.` が付きます。homeManager のものは `people.home.imports` で選びます。

- homeManager: `lang.bash` / `lang.buf` / `lang.c` / `lang.dockerfile` / `lang.elm` / `lang.github-actions` / `lang.go` / `lang.haskell` / `lang.jvm` / `lang.just` / `lang.lua` / `lang.nix` / `lang.node` / `lang.python` / `lang.rust` / `lang.toml` / `lang.typst` / `lang.wasm` / `lang.web`
- nixos: `amd` / `nvidia` / `iphone` / `claude-desktop` / `game` / `server`
- darwin: `ios-dev` / `omniwm`

### ディレクトリ

ディレクトリは OS ではなく機能ごとに分けています。どの OS 向けかは、ファイル内で書き足している class で分かります。
OS 固有の home 設定も `homeManager.*` の中で OS を判定せず、`nixos.*` / `darwin.*` から `people.home.imports` で入れます。
ただし `lang.*` は両 OS のホストが `people.home.imports` で選ぶ home 専用のモジュールなので、中で OS を判定します。

各ディレクトリに置くものの基準です。中身は網羅しません。

- `modules/`
  - `home-manager.nix`: home-manager の統合と層の配線
  - `users.nix`: `people.primaryUser` / `people.flakeHost` / `people.home`
  - `state-version.nix`: stateVersion
  - `nix/`: nix 自体、nixpkgs、nh の設定
  - `style/`: テーマ、フォント、壁紙などの見た目
  - `shell/`: 対話シェルと、シェルに組み込んで使う道具 (prompt、hook や alias で連携するもの、OS 差を埋める shim)
  - `editor/`: エディタ。言語ごとのツールは持たない
  - `terminal/`: 端末エミュレータ
  - `lang/`: 言語やファイル形式ごとの toolchain・language server・formatter・linter。1 つのファイルかディレクトリが 1 つの `lang.<名前>`
    - nvim が使うもの (language server、nvim から呼ぶ formatter・linter、DAP adapter) は `programs.neovim.extraPackages` に入れ、nvim の中からだけ見えるようにする。compiler・build tool・runtime・端末で使う CLI は `home.packages` に入れる
    - nvim が使うものを足したら、`nvim-config/lua/plugins/coding/` の対応する設定にも足す。lspconfig の server は `lsp.lua`、formatter は `format.lua`、linter は `lint.lua`、DAP adapter は `dap.lua`、専用の plugin を使う rust と jvm は `rust.lua` と `jvm.lua`。`lsp.lua`・`format.lua`・`lint.lua` は、実行ファイルが無いホストではその tool を使わない
  - `dev/`: 言語によらない開発ツール
  - `desktop/`: 画面を持つホストのデスクトップ環境と GUI アプリ
  - `macos/`: macOS にしかない設定とツール
  - `networking/`: ネットワークと VPN
  - `system/`: OS の基本的な設定と、`server` のような用途ごとの設定
  - `hardware/`: 特定のハードウェアと周辺機器
  - `flake/`: flake-parts 自体の設定（lint / eval check・formatter・devShell）
- `hosts/<name>/`: ホストごとの `nixosConfigurations` / `darwinConfigurations`

### 書き方

- パッケージは、書いている class の一覧に入れます。NixOS と nix-darwin は `environment.systemPackages`、home-manager は `home.packages`、macOS の GUI アプリは `homebrew.casks` です。専用の option があるもの (nvim が使う tool は `programs.neovim.extraPackages`、フォントは `fonts.packages`、ライブラリは `library.libs`) はそちらに入れます。`users.users.<user>.packages` は使いません。
- 他の module やホストから値を受け取る option (`library.libs`、`shell.interactiveVariables`、`style.fonts.monospace` など) は、その値を使う module で宣言します。
- 設定ファイルを生成する module は、生成した内容を検査する check を同じファイルに置きます (niri の設定、fish の設定、Claude Code の guard)。
- README の一覧のうち、任意の機能、Hosts、`modules/` 直下は網羅していて、`nix flake check` が実際の定義と照合します。ほかの説明は網羅しません。

## License

[MIT](./LICENSE)
