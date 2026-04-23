{ mkEnableOption, ... }:

{
  options.modules.darwin.enable = mkEnableOption "enable darwin settings";

  imports = [
    ./dock.nix
    ./finder.nix
    ./homebrew.nix
    ./aerospace.nix
  ];
}
