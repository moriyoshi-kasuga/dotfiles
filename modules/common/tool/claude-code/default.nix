{ mkEnableOption, ... }:

{
  options.modules.tool.claude-code.enable = mkEnableOption "enable claude-code";

  imports = [
    ./basic.nix
  ];
}
