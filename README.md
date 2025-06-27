# My Dotfiles for Development Environment

[![main](https://github.com/moriyoshi-kasuga/dotfiles/actions/workflows/main.yml/badge.svg)](https://github.com/moriyoshi-kasuga/dotfiles/actions/workflows/main.yml)

これは、私、[moriyoshi-kasuga](https://github.com/moriyoshi-kasuga)が作成した、macOSとLinux (WSL2) のための開発環境を構築するdotfilesです。
モダンで効率的なCUI中心の開発体験を、コマンド一つで再現することを目指しています。

## ✨ 特徴 (Features)

- **🚀 簡単なセットアップ**: `make init` を実行するだけで、環境構築が完了します。
- **🖥️ クロスプラットフォーム**: macOSとLinuxの両方に対応。共通の設定とOS固有の設定を管理しています。
- **🔧 モダンなツール群**: `zsh`, `neovim`, `tmux`, `wezterm` などを中心に、生産性を高めるためのモダンなツールを厳選しています。
- **⚙️ `Makefile` による管理**: 各種ツールのインストールや設定の適用を、`make <target>` 形式で簡単に行えます。
- **⚡️ 軽量かつ高速**: `sheldon` や `lazyvim` を採用し、シェルの起動やエディタの動作を高速に保ちます。

<!-- ## 📸 スクリーンショット (Screenshot) -->
<!-- *(ここにWeztermやNeovimのスクリーンショットを挿入すると、より魅力的になります)* -->

## 📦 インストール (Installation)

お使いのOSに合わせて、以下のコマンドを実行してください。

### macOS

```sh
git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles && cd ~/dotfiles && make init
```

### Linux (WSL2)

```sh
sudo apt update && sudo apt install -y make git && \
git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles && \
cd ~/dotfiles && make init
```

## 🛠️ 使い方 (Usage)

`Makefile` に定義されたコマンドを使って、各種設定を個別に管理できます。

| コマンド | 説明 |
| :--- | :--- |
| `make help` | 利用可能なすべてのコマンドを表示します |
| `make init` | 環境全体の初期セットアップを行います |
| `make link` | dotfilesへのシンボリックリンクを作成します |
| `make unlink` | シンボリックリンクを削除します |
| `make zsh` | Zshと関連プラグインを設定します |
| `make brew` | Homebrewでパッケージをインストールします |
| `make neovim` | Neovimと関連プラグインを設定します |
| `make git` | Gitのグローバル設定を行います |
| `make docker` | Dockerをインストール・設定します |
| `make node` | Node.js環境 (Volta) をセットアップします |
| `make python` | Python環境 (pyenv) をセットアップします |
| `make rust` | Rust環境 (rustup) をセットアップします |

## 🎨 カスタマイズ (Customization)

このdotfilesは、あなたの好みに合わせて簡単にカスタマイズできます。

- **Homebrewパッケージ**: `config/Brew.Unix.Brewfile` に追記・修正することで、インストールするパッケージを変更できます。OS固有のパッケージは `Brew.Darwin.Brewfile` や `Brew.Linux.Brewfile` を編集します。
- **Zsh**: `dotfiles/zsh/alias.zsh` にエイリアスを、`dotfiles/zsh/sheldon/plugins.toml` にプラグインを追加できます。
- **Neovim**: `dotfiles/lazyvim/lua/plugins/` 以下に `lazy.nvim` 形式で設定ファイルを追加することで、プラグインの追加や設定変更が可能です。
- **Git**: `dotfiles/.gitconfig` や `dotfiles/.gitconfigs/global.gitconfig` を編集して、Gitの設定を変更します。

## 🧰 主要ツール一覧 (Tools)

| ツール | 役割 | 設定ファイル |
| :--- | :--- | :--- |
| **Wezterm** | ターミナルエミュレータ | `dotfiles/.wezterm.lua` |
| **Zsh** | シェル | `dotfiles/.zshrc`, etc. |
| **Sheldon** | Zshプラグインマネージャ | `dotfiles/zsh/sheldon/plugins.toml` |
| **Starship** | プロンプト | `dotfiles/starship.toml` |
| **Neovim** | テキストエディタ | `dotfiles/lazyvim/` |
| **LazyVim** | Neovim設定フレームワーク | `dotfiles/lazyvim/lua/config/lazy.lua` |
| **Tmux** | ターミナルマルチプレクサ | `dotfiles/.tmux.conf` |
| **eza** | `ls` の代替 | - |
| **bat** | `cat` の代替 | `bin/bat.sh` |
| **fzf** | 曖昧検索ツール | - |
| **lazygit** | GitのTUIクライアント | `dotfiles/lazygit.yml` |
| **lazydocker** | DockerのTUIクライアント | `dotfiles/lazydocker.yml` |
| **Volta** | Node.jsバージョン管理 | `bin/lang/node.sh` |
| **pyenv** | Pythonバージョン管理 | `bin/lang/python.sh` |
| **rustup** | Rustバージョン管理 | `bin/lang/rust.sh` |

## 📜 ライセンス (License)

[MIT](./LICENSE)
