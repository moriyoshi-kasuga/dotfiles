# My Dotfiles for Development Environment

macOS と NixOS のための開発環境を構築する `dotfiles` です（Nix さえ入っていれば、Nix Flakes で OS 依存でない設定だけを適用することもできます）。

[Nix](https://nixos.org/) と [Home Manager](https://github.com/nix-community/home-manager) を利用し、宣言的で再現性の高い環境構築を目指しています。

## ✨ Features

- **宣言的な環境構築**: Nix Flakes を用いて、開発環境の依存関係や設定をコードとして管理します。
- **再現性**: どこでも同じ環境を簡単に再現できます。
- **クロスプラットフォーム**: macOS (nix-darwin) と NixOS をサポート。
- **簡単なセットアップ**: `vars.nix` を設定し `./init.sh` を実行するだけで、環境構築が完了します。
- **Home Manager**: 設定ファイル（ドットファイル）とパッケージ管理を Home Manager で一元管理します。
- **モダンなツール群**: `zsh`, `fish`, `neovim`, `tmux`, `wezterm` などを中心に、生産性を高めるためのモダンなツールを厳選しています。
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

    `vars.nix` 内で、`username`, `system` などを設定してください。

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

`.nix` ファイルや設定を変更した後は、再度 `./init.sh` を実行することで変更を適用できます。

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

この `dotfiles` は、以下のディレクトリ配下のファイルを編集することでカスタマイズします。

### 共通設定 (Home Manager)

- **パッケージの追加・削除**: `home/default.nix` や `home/**/*.nix` の `home.packages` を編集します。
- **Neovim**: `home/editors/neovim/` 配下の Nix 設定および Lua 設定を編集します。
- **Zsh**: `home/shells/zsh/` 配下の設定を編集します。
- **Git**: `home/tools/git/` 配下の設定を編集します。

### NixOS 固有の設定

- **システム設定**: `hosts/nixos/default.nix` でデスクトップ環境、ユーザー設定などを管理。
- **フォント**: `hosts/nixos/fonts.nix` でシステムフォントを設定。
- **ネットワーク**: `hosts/nixos/network.nix` でホスト名とネットワーク設定。
- **仮想化**: `hosts/nixos/virtualisation.nix` で Docker 設定。

### macOS 固有の設定

- **システム設定**: `hosts/darwin/default.nix` で macOS システム設定。
- **Dock / Finder**: `hosts/darwin/dock.nix`, `hosts/darwin/finder.nix` で設定。

## 📁 ディレクトリ構造 (Directory Structure)

```txt
.
├── flake.nix                 # Flake エントリーポイント
├── vars.nix.example          # 設定テンプレート
├── init.sh                   # セットアップスクリプト
├── home/                     # Home Manager 設定 (ユーザー環境)
│   ├── default.nix           # Home Manager メイン設定
│   ├── editors/              # エディタ設定 (Neovim, Vim)
│   ├── shells/               # シェル設定 (Zsh)
│   ├── terminals/            # ターミナル設定 (WezTerm)
│   ├── tools/                # CLI ツール (Git, tmux, yazi, etc.)
│   ├── lang/                 # 言語別開発環境 (Rust, Python, Go, Node.js, etc.)
│   ├── linux/                # Linux 固有のユーザー設定 (Niri, etc.)
│   └── darwin/               # macOS 固有のユーザー設定
└── hosts/                    # システムレベル設定 (OS設定)
    ├── nixos/                # NixOS システム設定
    └── darwin/               # macOS システム設定 (nix-darwin)
```

## 🧰 主要ツール一覧 (Tools)

### ターミナル・シェル

| ツール | 役割 | 設定場所 |
| :--- | :--- | :--- |
| **WezTerm** | Terminal Emulator | `home/terminals/wezterm/` |
| **Zsh** | Shell | `home/shells/zsh/` |
| **Starship** | Prompt | `home/shells/zsh/starship.nix` |
| **Tmux** | Terminal Multiplexer | `home/tools/tmux/` |

### エディタ

| ツール | 役割 | 設定場所 |
| :--- | :--- | :--- |
| **Neovim** | Text Editor | `home/editors/neovim/` |
| **Vim** | Text Editor | `home/editors/vim/` |

### Git ツール

| ツール | 役割 | 設定場所 |
| :--- | :--- | :--- |
| **Git** | Version Control | `home/tools/git/` |
| **Lazygit** | Git TUI Client | `home/tools/git/lazygit.nix` |
| **Delta** | Git Diff Viewer | `home/tools/git/delta.nix` |

### CLI ツール (一部)

| ツール | 役割 | 設定場所 |
| :--- | :--- | :--- |
| **yazi** | Terminal File Manager | `home/tools/default.nix` |
| **fzf** | 曖昧検索ツール | `home/shells/zsh/fzf.nix` |
| **zoxide** | `cd` の代替 | `home/shells/zsh/zoxide.nix` |
| **ripgrep** | 高速検索ツール | `home/tools/default.nix` |

## 🖥️ NixOS 固有の機能

この `dotfiles` は NixOS 上で以下の機能を提供します:

- **ウィンドウマネージャー**: Niri (Wayland)
- **ディスプレイマネージャー**: SDDM
- **フォント**: Nerd Fonts (JetBrains Mono, Commit Mono), Noto Fonts
- **オーディオ**: PipeWire (Bluetooth 対応)
- **仮想化**: Rootless Docker
- **アプリケーション**: Brave, Discord, Slack, etc.

## 📜 License

[MIT](./LICENSE)
