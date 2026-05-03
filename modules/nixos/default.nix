{ mkEnableOption, ... }:

{
  options.modules.nixos.enable = mkEnableOption "enable nixos";

  imports = [
    ./gui
    ./basic.nix
    ./i18n.nix
    ./network.nix
    ./tailscale.nix
  ];
}
