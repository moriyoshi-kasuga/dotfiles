{
  lib,
  mkModule,
  pkgs,
  username,
  ...
}:

with lib;
let
  package = pkgs.zsh;
in
mkModule {
  name = "shell.zsh";
  options = {
    default = mkEnableOption "Use zsh to default shell";
  };
  module = cfg: {
    programs.zsh = {
      enable = true;
      inherit package;
    };
    environment.shells = [ package ];

    users.users.${username}.shell = mkIf cfg.default package;
  };
}
