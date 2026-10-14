{ config, lib, ... }:

{
  # 各 module の fish の断片は home-manager が 1 つの config.fish にまとめる。まとめるときに通す
  # fish_indent は構文エラーでも成功するので、まとめた後の内容を host ごとに fish で検査する。
  perSystem =
    { pkgs, ... }:
    {
      checks = lib.mapAttrs' (
        name: cfg:
        let
          hm = cfg.config.home-manager.users.${cfg.config.people.primaryUser};
          # source を build すると内容が参照する store path (LD_LIBRARY_PATH のライブラリなど) を
          # すべて realize することになるので、fish_indent に渡す前の text から検査する。
          # text は store path を含むだけで system に依らないので、他の OS の host も検査できる。
          text = builtins.unsafeDiscardStringContext hm.xdg.configFile."fish/config.fish".source.text;
        in
        lib.nameValuePair "fish-config-${name}" (
          pkgs.runCommand "fish-config-${name}" { nativeBuildInputs = [ pkgs.fish ]; } ''
            HOME=$TMPDIR fish --no-execute ${pkgs.writeText "config.fish" text}
            touch "$out"
          ''
        )
      ) (config.flake.nixosConfigurations // config.flake.darwinConfigurations);
    };

  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    {
      programs.fish = {
        enable = true;
        package = pkgs.fish;
        # 他の module (lang.rust, homebrew など) の fish_add_path より先に評価させる。
        # fish_add_path は先頭に追加するので、後に評価されたものほど PATH で優先される。
        interactiveShellInit = lib.mkBefore (builtins.readFile ./init.fish);
      };
    };

  flake.modules.nixos.base = {
    programs.fish.enable = true;
  };

  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      environment.shells = [ pkgs.fish ];
    };
}
