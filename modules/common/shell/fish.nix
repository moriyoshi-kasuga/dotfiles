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
  nixosModule = cfg: {
    users.users.${username}.shell = mkIf cfg.default package;
  };
  darwinModule = cfg: {
    environment.shells = [ package ];
    users.users.${username}.shell = mkIf cfg.default package;
  };
}
