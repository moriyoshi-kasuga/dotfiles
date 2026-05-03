{ mkEnableOption, ... }:

{
  options.modules.nixos.gui.enable = mkEnableOption "enable gui on nixos";

  imports = [
    ./audio.nix
    ./basic.nix
    ./bluetooth.nix
    ./brave.nix
    ./game.nix
    ./i18n.nix
    ./niri.nix
    ./nvidia.nix
    ./qt.nix
    ./sddm.nix
    ./thunar.nix
    ./zathura.nix
  ];
}
