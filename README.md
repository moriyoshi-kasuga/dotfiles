# 私が作った自分のための開発環境の dotfile です

## Install

それぞれのコマンドをターミナルで実行すればインストールされます。

### Mac

```sh
git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles && cd ~/dotfiles && make init
```

> **ここでエラーが吐く場合は自分で調べてください、私の環境ではエラーは吐きませんでした**

### Linux (Ubuntu,WSL)

```sh
sudo apt install make && git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles && cd ~/dotfiles && make init
```

<details>
<summary>エラーを吐く場合は、この手段をしてください</summary>

> 1. **Ubuntu** で
>
>    ```sh
>    sudo vim /etc/wsl.conf
>    ```
>
>    を 実行して 下記を追加して保存してください。
>
>    ```text
>    [network]
>    generateResolvConf = false
>    ```
>
> 2. **Windows PowerShell** で
>
>    ```sh
>    wsl --shutdown
>    ```
>
>    を 実行して **Ubuntu** を再起動してください。
>
> 3. **Ubuntu** で
>
>    ```sh
>    sudo vim /etc/resolv.conf
>    ```
>
>    を 実行して 下記を追加して保存してください。
>
>    ```text
>    nameserver 8.8.8.8
>    ```
>
> 4. そしたら **Ubuntu** の Shell で もう一回 **インストールのコマンド** を実行してください。

</details>

## インストールされるもの一覧

- Homebrew

  - [eza](https://github.com/eza-community/eza)
  - [bat](https://github.com/sharkdp/bat)
  - [fzf](https://github.com/junegunn/fzf)
  - [direnv](https://github.com/direnv/direnv)
  - [lazygit](https://github.com/jesseduffield/lazygit)
  - [startship](https://github.com/starship/starship)
  - [tmux](https://github.com/tmux/tmux)
  - [git-delta](https://github.com/dandavison/delta)
  - [and more...](./config/Brew.Unix.Brewfile)

- git
- docker
  > docker and docker compose
- zsh
  - zsh plugin manager using `sheldon`
  - use keybind of vim
  - [my alias](./dotfiles/zsh/alias.zsh)
  - [my useful command](./dotfiles/zsh/script/)
- nodebrew
  > latest npm and node
- python
- neovim
  - I used to use [lazyvim + my settings](./dotfiles/lazyvim/)
