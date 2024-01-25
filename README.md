# 私が作った自分のための開発環境の dotfile です

## Install

それぞれのコマンドをターミナルで実行すればインストールされます。

### Mac

```
git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles && cd ~/dotfiles && make
```

> **ここでエラーが吐く場合は自分で調べてください、私の環境ではエラーは吐きませんでした**

### Linux (Ubuntu,WSL)

```
sudo apt install make && git clone --depth 1 https://github.com/moriyoshi-kasuga/dotfiles.git ~/dotfiles && cd ~/dotfiles && make
```

<details>
<summary>エラーを吐く場合は、この手段をしてください</summary>

> 1.  **Ubuntu** で
>     ```
>     sudo vim /etc/wsl.conf
>     ```
>     を 実行して 下記を追加して保存してください。
>     ```
>     [network]
>     generateResolvConf = false
>     ```
> 2.  **Windows PowerShell** で
>
>     ```
>     wsl --shutdown
>     ```
>
>     を 実行して **Ubuntu** を再起動してください。
>
> 3.  **Ubuntu** で
>     ```
>     sudo vim /etc/resolv.conf
>     ```
>     を 実行して 下記を追加して保存してください。
>     ```
>     nameserver 8.8.8.8
>     ```
> 4.  そしたら **Ubuntu** の Shell で もう一回 **インストールのコマンド** を実行してください。

</details>

## インストールされるもの一覧

- Homebrew

  - [lsd](https://github.com/lsd-rs/lsd)
  - [bat](https://github.com/sharkdp/bat)
  - [fzf](https://github.com/junegunn/fzf)
  - [direnv](https://github.com/direnv/direnv)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [lazygit](https://github.com/jesseduffield/lazygit)
  - [wget](https://www.gnu.org/software/wget/)
  - [tmux](https://github.com/tmux/tmux)
  - [and more...](./config/Brew.Unix.Brewfile)

- git
- docker
  > docker and docker compose
- zsh
  > zsh plugin manager using `zinit` and customize theme using `p10k`
  - my alias
  - original fzf history of <Ctrl+R>
  - original directory history with <Ctrl+G>
- nodebrew
  > latest npm and node
- python
- neovim
  - [lazyvim + my settings](./dotfiles/lazyvim/)
    > I used to use ([astronvim](https://github.com/AstroNvim/AstroNvim) and [my astronvim config](https://github.com/moriyoshi-kasuga/astronvim_config))
- coursier
  > setup and install metals
