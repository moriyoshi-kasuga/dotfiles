{ mkEnableOption, ... }:

{
  options.modules.shell.enable = mkEnableOption "enable shell settings";

  imports = [
    ./basic.nix
    ./fish.nix
    ./zsh.nix
  ];
}
