{ mkEnableOption, ... }:

{
  options.modules.tool.git.enable = mkEnableOption "enable git settings";

  imports = [
    ./basic.nix
    ./delta.nix
    ./lazygit.nix
  ];
}
