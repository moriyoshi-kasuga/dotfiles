{
  mkModule,
  pkgs,
  ...
}:

let
  package = pkgs.fish;
in
mkModule {
  name = "fish";
  module = {
    programs.fish = {
      enable = true;
      inherit package;
    };
    environment.shells = [ package ];
  };
}
