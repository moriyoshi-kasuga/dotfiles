{ mkEnableOption, ... }:

{
  options.modules.tool.enable = mkEnableOption "enable tool settings";

  imports = [
    ./git
    ./tmux
    ./basic.nix
    ./docker.nix
    ./tff.nix
    ./claude-code
  ];
}
