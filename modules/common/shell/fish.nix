{
  lib,
  pkgs,
  mkModule,
  username,
  ...
}:

with lib;
let
  package = pkgs.fish;
in
mkModule {
  name = "shell.fish";
  inheritModule = "shell";
  options = {
    default = mkEnableOption "Use zsh to default shell";
  };
  commonModule = {
    programs.fish.enable = true;
  };
  homeModule = {
    programs.fish = {
      inherit package;
      interactiveShellInit = builtins.readFile ./init.fish;
    };
  };
  nixosModule =
    { cfg, ... }:
    {
      users.users.${username}.shell = mkIf cfg.default package;
      environment.variables = {
        LIBRARY_PATH = "${pkgs.libiconv}/lib:/usr/lib";
      };
    };
  darwinModule =
    { cfg, ... }:
    {
      environment.shells = [ package ];
      users.users.${username}.shell = mkIf cfg.default package;
    };
}
