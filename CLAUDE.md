# dotfiles

module や host の置き場所と書き方は、README.md の「Hosts」と「Module Hierarchy」に従う。

## 方針

- `flake.modules.<class>.<aspect>` を直接書き、設計は dendritic pattern と import-tree に任せる。その上に載せる wrapper、mkHost のような helper、全ファイルに渡させる独自 key は作らず、提案もしない。1 ファイルの中で nixos と darwin の設定を共通化する let (`modules/users.nix` の mkUserModule など) は構わない。
- 構成の改善は、module の置き場所と aspect の切り方、host の import の構成、設定の中身を対象にする。新しい仕組み (option、生成、script) を増やさない形を優先し、直し忘れは flake check で見つける。
- README には最新の構成だけを書く。移行の手順や以前の構成は、README ではなくチャットで伝える。
- commit と switch はユーザーがする。

## 検証

- 変更したら `nix flake check` を通す。全 host の評価、lint、生成した設定の検査、README の一覧の照合が走る。
- flake は git が追跡しているファイルしか見ないので、新しいファイルは評価の前に `git add` する。
- refactor (動作を変えないはずの変更) は、全 host の `config.system.build.toplevel.drvPath` を main と比べ、一致するか、違いをすべて説明できたら完了にする。
  - main は `mkdir <dir> && git archive main | tar -x -C <dir>` で取り出す。`nix eval --raw <flake>#nixosConfigurations.<host>.config.system.build.toplevel.drvPath` (darwin は `darwinConfigurations`) を、`<flake>` を `path:<dir>` と `.` にして比べる。
  - ファイルを移すと module の評価順が変わり、list の順序だけが変わって drvPath がずれることがある (home-manager-path、home-manager-fonts、nvim の wrapper)。そのときは `home.packages`、`programs.neovim.extraPackages`、`environment.systemPackages` などを host ごとに評価し、集合にして比べる。
  - 既定値と同じだから消す設定も、option の default を読むのではなく drvPath の一致で確かめる。
