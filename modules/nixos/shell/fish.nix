{
  lib,
  mkModule,
  pkgs,
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
  module = cfg: {
    programs.fish = {
      enable = true;
      inherit package;
    };

    users.users.${username}.shell = mkIf cfg.default package;
  };
}
