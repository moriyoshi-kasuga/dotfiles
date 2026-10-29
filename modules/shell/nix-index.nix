{ inputs, ... }:

{
  # ビルド済みの nix-index の DB で、コマンドがどのパッケージにあるかを nix-locate で引けるようにする。
  flake.modules.homeManager.base = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];

    programs.nix-index = {
      enable = true;
      # 入っていないコマンドを打つたびに DB を引いて待たされるので、fish の command-not-found には繋がない
      enableFishIntegration = false;
    };
    # `, <command>` でインストールせずに一度だけ実行する
    programs.nix-index-database.comma.enable = true;
  };
}
