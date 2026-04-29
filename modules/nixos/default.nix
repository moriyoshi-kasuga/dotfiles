{ mkEnableOption, ... }:

{
  options.modules.nixos.enable = mkEnableOption "enable nixos";

  imports = [
    ./gui
    ./audio.nix
    ./basic.nix
    ./bluetooth.nix
    ./docker.nix
    ./i18n.nix
    ./network.nix
    ./tailscale.nix
  ];
}
