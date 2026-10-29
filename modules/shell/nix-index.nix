{ inputs, ... }:

{
  # 入っていないコマンドを打ったときに、どのパッケージにあるかを fish が教えてくれる。
  # programs.command-not-found は channel 前提で動かないので、ビルド済みの nix-index の DB で代わりにする。
  flake.modules.homeManager.base = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];

    programs.nix-index.enable = true;
    # `, <command>` でインストールせずに一度だけ実行する
    programs.nix-index-database.comma.enable = true;
  };
}
