# My Dotfiles for Development Environment

[![main](https://github.com/moriyoshi-kasuga/dotfiles/actions/workflows/main.yaml/badge.svg)](https://github.com/moriyoshi-kasuga/dotfiles/actions/workflows/main.yaml)

これは、私、[moriyoshi-kasuga](https://github.com/moriyoshi-kasuga)が作成した、macOSとLinuxのための開発環境を構築するdotfilesです。
[Nix](https://nixos.org/)と[Home Manager](https://github.com/nix-community/home-manager)を利用し、宣言的で再現性の高い環境構築を目指しています。

## ✨ Features

- **宣言的な環境構築**: Nix Flakesを用いて、開発環境の依存関係や設定をコードとして管理します。
- **再現性**: どこでも同じ環境を簡単に再現できます。
- **クロスプラットフォーム**: macOS (darwin) と Linux をサポート。
- **簡単なセットアップ**: `vars.nix` を設定し `./init.sh` を実行するだけで、環境構築が完了します。
- **Home Manager**: dotfilesのシンボリックリンクや package 管理をHome Managerで一元管理します。
- **モダンなツール群**: `zsh`, `neovim`, `tmux`, `wezterm` などを中心に、生産性を高めるためのモダンなツールを厳選しています。

## Prerequisites

- [Nix](https://nixos.org/download.html) がインストールされていること。
- `git`がインストールされていること。

## 📦 Installation

1. **リポジトリのクローン**

    ```sh
    git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2. **config file を作成・編集**
    `vars.nix.example` を `vars.nix` にコピーし、あなたの環境に合わせて内容を編集します。

    ```sh
    cp vars.nix.example vars.nix
    ```

    `vars.nix` file 内で、`username`, `hostDirectory`, `system` などを設定してください。

3. **初期化 script を実行**
    以下の command を実行すると、Nix Flakeの設定が適用され、環境構築が完了します。

    ```sh
    ./init.sh
    ```

## 🛠️ 設定の適用 (Apply Configuration)

`.nix` file やdotfilesの設定を変更した後は、再度 `init.sh` を実行することで、変更を適用できます。

```sh
# 変更を適用
./init.sh
```

## 🎨 カスタマイズ (Customization)

このdotfilesは、以下の file や directory を編集することでカスタマイズします。

- **package の追加・削除**: `home.nix` や `modules/**/*.nix` の `home.packages` を編集します。
- **Neovim**: `modules/editor/neovim.nix` や `dotfiles/lazyvim/` 以下の設定を編集します。
- **Zsh**: `modules/zsh/default.nix` や `dotfiles/.zshrc` を編集します。
- **新しい module の追加**: `modules/` directory に新しい `.nix` file を作成し、`home.nix` からインポートします。

## 🧰 主要ツール一覧 (Tools)

| ツール | 役割 | 設定 file / module |
| :--- | :--- | :--- |
| **Nix** | Package Manager | `flake.nix`, `home.nix` |
| **Home Manager** | dotfiles管理 | `home.nix` |
| **Wezterm** | Terminal Emulator | `dotfiles/.wezterm.lua` |
| **Zsh** | Shell | `modules/zsh/default.nix` |
| **Starship** | Prompt | `modules/zsh/starship.nix` |
| **Neovim** | Text Editor | `modules/editor/neovim.nix` |
| **LazyVim** | Neovim Configuration Framework | `dotfiles/lazyvim/` |
| **Tmux** | Terminal Multiplexer | `modules/tools/tmux.nix` |
| **eza** | `ls` の代替 | `modules/zsh/eza.nix` |
| **fzf** | 曖昧検索ツール | `modules/zsh/fzf.nix` |
| **lazygit** | Git TUI Client | `modules/git/lazygit.nix` |
| **lazydocker** | Docker TUI Client | `modules/tools/lazydocker.nix` |

## 📜 License

[MIT](./LICENSE)
