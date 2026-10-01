_:

{
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
