{ mkEnableOption, ... }:

{
  options.modules.tool.enable = mkEnableOption "enable tool settings";

  imports = [
    ./git
    ./tmux
    ./basic.nix
    ./docker.nix
    ./opencode.nix
    ./tff.nix
  ];
}
