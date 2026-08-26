_:

{
  flake.modules.homeManager."shell.fish" =
    { pkgs, ... }:
    {
      programs.fish = {
        package = pkgs.fish;
        interactiveShellInit = builtins.readFile ./init.fish;
      };
    };

  flake.modules.nixos."shell.fish" = {
    programs.fish.enable = true;
  };

  flake.modules.darwin."shell.fish" =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      environment.shells = [ pkgs.fish ];
    };
}
