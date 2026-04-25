{ mkEnableOption, ... }:

{
  options.modules.nixos.gui.enable = mkEnableOption "enable gui on nixos";

  imports = [
    ./basic.nix
    ./brave.nix
    ./game.nix
    ./niri.nix
    ./nvidia.nix
    ./qt.nix
    ./sddm.nix
    ./thunar.nix
    ./zathura.nix
  ];
}
