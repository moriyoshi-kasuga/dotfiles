{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./hardware.nix
    ./desktop.nix
    ./users.nix
  ];

  home-manager.backupFileExtension = "nixbackup";
  system.stateVersion = "25.05";
}