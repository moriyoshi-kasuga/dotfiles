# My Dotfiles for Development Environment

macOS と NixOS のための開発環境を構築する `dotfiles` です（Nix さえ入っていれば、Nix Flakes で OS 依存でない設定だけを適用することもできます）

[Nix](https://nixos.org/) と [Home Manager](https://github.com/nix-community/home-manager) を利用し、宣言的で再現性の高い環境構築を目指しています。

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

## 📜 License

[MIT](./LICENSE)
