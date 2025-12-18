# My Dotfiles for Development Environment

macOS と NixOS のための開発環境を構築する `dotfiles` です（Nix さえ入っていれば、Nix Flakes で OS 依存でない設定だけを適用することもできます）。

[Nix](https://nixos.org/) と [Home Manager](https://github.com/nix-community/home-manager) を利用し、宣言的で再現性の高い環境構築を目指しています。

## ✨ Features

- **宣言的な環境構築**: Nix Flakes を用いて、開発環境の依存関係や設定をコードとして管理します。
- **再現性**: どこでも同じ環境を簡単に再現できます。
- **クロスプラットフォーム**: macOS (nix-darwin) と NixOS をサポート。
- **簡単なセットアップ**: `vars.nix` を設定し `./init.sh` を実行するだけで、環境構築が完了します。
- **Home Manager**: `dotfiles` のシンボリックリンクやパッケージ管理を Home Manager で一元管理します。
- **モダンなツール群**: `zsh`, `neovim`, `tmux`, `wezterm` などを中心に、生産性を高めるためのモダンなツールを厳選しています。
- **NixOS システム統合**: NixOS 上では、デスクトップ環境、フォント、仮想化などのシステムレベル設定も管理します。

## ✅ Prerequisites (前提条件)

- [Nix](https://nixos.org/download.html) がインストールされていること。
- `git` がインストールされていること。

## 📦 Installation (インストール)

### ホストマシンへのインストール

1. **リポジトリのクローン**

    ```sh
    git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2. **設定ファイルを作成・編集**

    `vars.nix.example` を `vars.nix` にコピーし、あなたの環境に合わせて内容を編集します。

    ```sh
    cp vars.nix.example vars.nix
    ```

    `vars.nix` 内で、`username`, `homeDirectory`, `system` などを設定してください。

    - **NixOS**: `system = "x86_64-linux"` または `"aarch64-linux"`
    - **macOS**: `system = "aarch64-darwin"` または `"x86_64-darwin"`

3. **初期化スクリプトを実行**

    **NixOS の場合:**

    ```sh
    ./init.sh nixos
    ```

    **macOS の場合:**

    ```sh
    ./init.sh darwin
    ```

    **Home Manager のみ (Nix on Linux など):**

    ```sh
    ./init.sh flake
    ```

## 🛠️ 設定の適用 (Apply Configuration)

`.nix` ファイルや `dotfiles` の設定を変更した後は、再度 `./init.sh` を実行することで変更を適用できます。

```sh
# NixOS の場合
./init.sh nixos

# macOS の場合
./init.sh darwin

# Home Manager のみの場合
./init.sh flake

# Flake の依存関係を更新
./init.sh update
```

## 🎨 カスタマイズ (Customization)

この `dotfiles` は、以下のファイルやディレクトリを編集することでカスタマイズします。

### 共通設定

- **パッケージの追加・削除**: `home/default.nix` や `home/**/*.nix` の `home.packages` を編集します。
- **Neovim**: `home/editor/neovim.nix` や `dotfiles/neovim/` 以下の設定を編集します。
- **Zsh**: `home/zsh/default.nix` や `dotfiles/.zshrc` を編集します。
- **Git**: `home/git/` 以下の設定を編集します。

### NixOS 固有の設定

- **システム設定**: `hosts/nixos/default.nix` でデスクトップ環境、ユーザー設定などを管理。
- **フォント**: `hosts/nixos/fonts.nix` でシステムフォントを設定。
- **ネットワーク**: `hosts/nixos/network.nix` でホスト名とネットワーク設定。
- **仮想化**: `hosts/nixos/virtualisation.nix` で Docker 設定。
- **地域設定**: `hosts/nixos/region.nix` でタイムゾーンと言語設定。

### macOS 固有の設定

- **システム設定**: `hosts/darwin/default.nix` で macOS システム設定。
- **Dock**: `hosts/darwin/dock.nix` で Dock の設定。
- **Finder**: `hosts/darwin/finder.nix` で Finder の設定。

### 新しいモジュールの追加

`home/` に新しい `.nix` ファイルを作成し、`home/default.nix` からインポートします。

## 📁 ディレクトリ構造 (Directory Structure)

```txt
.
├── flake.nix                 # Flake エントリーポイント
├── vars.nix.example          # 設定テンプレート
├── init.sh                   # セットアップスクリプト
├── dev.sh                    # Docker 環境管理スクリプト
├── docker/                   # Docker 開発環境
│   ├── Dockerfile            # Docker イメージ定義
│   └── compose.yaml          # Docker Compose 設定
├── home/                     # Home Manager 設定
│   ├── default.nix           # Home Manager メイン設定
│   ├── pkg.nix               # PKG_CONFIG_PATH と LD_LIBRARY_PATH 管理
│   ├── editor/               # エディタ設定 (Neovim, Vim)
│   ├── git/                  # Git, Lazygit, Delta 設定
│   ├── lang/                 # 言語別開発環境 (Rust, Python, Go, Node.js など)
│   ├── tools/                # CLI ツール (tmux, docker, yazi など)
│   ├── zsh/                  # Zsh, Starship, fzf, eza など
│   ├── linux/                # Linux 固有設定
│   └── darwin/               # macOS 固有設定
├── hosts/                    # システムレベル設定
│   ├── nixos/                # NixOS システム設定
│   │   ├── default.nix       # メインシステム設定
│   │   ├── fonts.nix         # フォント設定
│   │   ├── network.nix       # ネットワーク設定
│   │   ├── nix.nix           # Nix デーモン設定
│   │   ├── region.nix        # タイムゾーン・言語設定
│   │   └── virtualisation.nix # Docker 仮想化設定
│   └── darwin/               # macOS システム設定 (nix-darwin)
└── dotfiles/                 # ドットファイル
    ├── neovim/               # Neovim 設定
    ├── wezterm/              # WezTerm 設定
    ├── zsh-scripts/          # Zsh スクリプト
    ├── .zshrc                # Zsh 設定
    ├── .wezterm.lua          # WezTerm メイン設定
    └── tmux.conf             # Tmux 設定
```

## 🧰 主要ツール一覧 (Tools)

### システム管理

| ツール | 役割 | 設定ファイル / モジュール |
| :--- | :--- | :--- |
| **Nix** | Package Manager | `flake.nix`, `home/default.nix` |
| **Home Manager** | dotfiles 管理 | `home/default.nix` |
| **nix-darwin** | macOS システム管理 | `hosts/darwin/` (macOS のみ) |
| **NixOS** | Linux システム管理 | `hosts/nixos/` (NixOS のみ) |

### ターミナル・シェル

| ツール | 役割 | 設定ファイル / モジュール |
| :--- | :--- | :--- |
| **WezTerm** | Terminal Emulator | `dotfiles/.wezterm.lua` |
| **Zsh** | Shell | `home/zsh/default.nix`, `dotfiles/.zshrc` |
| **Starship** | Prompt | `home/zsh/starship.nix` |
| **Tmux** | Terminal Multiplexer | `home/tools/tmux.nix`, `dotfiles/tmux.conf` |

### エディタ

| ツール | 役割 | 設定ファイル / モジュール |
| :--- | :--- | :--- |
| **Neovim** | Text Editor | `home/editor/neovim.nix` |
| **Neovim Config** | Neovim Configuration | `dotfiles/neovim/` |
| **Vim** | Text Editor | `home/editor/vim.nix`, `dotfiles/.vimrc` |

### Git ツール

| ツール | 役割 | 設定ファイル / モジュール |
| :--- | :--- | :--- |
| **Git** | Version Control | `home/git/default.nix` |
| **Lazygit** | Git TUI Client | `home/git/lazygit.nix` |
| **Delta** | Git Diff Viewer | `home/git/delta.nix` |
| **git-cliff** | Changelog Generator | `home/tools/default.nix` |
| **gh** | GitHub CLI | `home/tools/default.nix` |

### CLI ツール

| ツール | 役割 | 設定ファイル / モジュール |
| :--- | :--- | :--- |
| **ripgrep** | 高速検索ツール | `home/tools/default.nix` |
| **fd** | `find` の代替 | `home/tools/default.nix` |
| **bat** | `cat` の代替 | `home/tools/default.nix` |
| **eza** | `ls` の代替 | `home/zsh/eza.nix` |
| **fzf** | 曖昧検索ツール | `home/zsh/fzf.nix` |
| **zoxide** | `cd` の代替 | `home/zsh/zoxide.nix` |
| **yazi** | Terminal File Manager | `home/tools/yazi.nix` |
| **jq** / **jid** | JSON Processor | `home/tools/default.nix` |
| **xh** | HTTP Client | `home/tools/default.nix` |
| **dust** | `du` の代替 | `home/tools/default.nix` |
| **bottom** | System Monitor | `home/tools/default.nix` |
| **tailspin** | Log Viewer | `home/tools/default.nix` |
| **glow** | Markdown Viewer | `home/tools/default.nix` |
| **lnav** | Log Navigator | `home/tools/default.nix` |
| **tldr** | Command Examples | `home/tools/default.nix` |

### コンテナ・仮想化

| ツール | 役割 | 設定ファイル / モジュール |
| :--- | :--- | :--- |
| **Docker** | Container Platform | `home/tools/docker.nix`, `hosts/nixos/virtualisation.nix` |
| **Lazydocker** | Docker TUI Client | `home/tools/lazydocker.nix` |
| **kind** | Kubernetes in Docker | `home/tools/default.nix` |
| **helm** | Kubernetes Package Manager | `home/tools/default.nix` |

### 開発言語・ツール

| 言語/ツール | 設定ファイル / モジュール |
| :--- | :--- |
| **Rust** | `home/lang/rust.nix` |
| **Python** | `home/lang/python.nix` |
| **Go** | `home/lang/go.nix` |
| **Node.js** | `home/lang/node.nix` |
| **Haskell** | `home/lang/haskell.nix` |
| **C/C++** | `home/lang/c.nix` |

### その他

| ツール | 役割 | 設定ファイル / モジュール |
| :--- | :--- | :--- |
| **direnv** | 環境変数管理 | `home/zsh/direnv.nix` |
| **fastfetch** | System Information | `home/default.nix` |
| **nixfmt-rfc-style** | Nix Formatter | `home/default.nix` |
| **AI Tools** (ask) | AI アシスタント | `home/zsh/ai.nix` |

## 🖥️ NixOS 固有の機能

この `dotfiles` は NixOS 上で以下の機能を提供します:

- **ウィンドウマネージャー**: Niri (スクロール可能なタイリング Wayland コンポジタ)
- **ディスプレイマネージャー**: SDDM (Wayland 対応)
- **グラフィックス**: NVIDIA GPU サポート (Optimus 対応)
- **フォント**: Nerd Fonts (JetBrains Mono, Commit Mono), Noto Fonts (CJK 対応)
- **オーディオ**: PipeWire (Bluetooth オーディオ対応)
- **仮想化**: Rootless Docker
- **ネットワーク**: NetworkManager, Tailscale
- **ゲーミング**: Steam サポート
- **アプリケーション**: Brave, Discord, Slack, Aseprite, LDtk

## 📜 License

[MIT](./LICENSE)
