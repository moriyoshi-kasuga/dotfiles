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
  options = {
    default = mkEnableOption "Use zsh to default shell";
  };
  commonModule = {
    modules.shell.enable = true;
    programs.fish.enable = true;
  };
  homeModule = {
    programs.fish = {
      inherit package;
      interactiveShellInit = builtins.readFile ./init.fish;
    };
  };
  nixosModule = cfg: {
    programs.fish.package = package;
    users.users.${username}.shell = mkIf cfg.default package;
  };
  darwinModule = cfg: {
    environment.shells = [ package ];
    users.users.${username}.shell = mkIf cfg.default package;
  };
}
