{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  program = "program";
  cfg = config.modules."${program}";
in
{
  options.modules."${program}" = {
    enable = mkEnableOption program;
  };
  config = mkIf cfg.enable {
  };
}
