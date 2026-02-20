{
  lib,
  config,
  ...
}:

with lib;
let
  program = "fish";
  cfg = config.modules."${program}";
in
{
  options.modules."${program}" = {
    enable = mkEnableOption program;
  };
  config = mkIf cfg.enable {
    module.shell.enable = true;

    programs.fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./init.fish;
    };
  };
}
