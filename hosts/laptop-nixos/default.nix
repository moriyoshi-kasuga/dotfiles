{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
  home = inputs.self.modules.homeManager;
in
{
  flake.nixosConfigurations.laptop-nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos."profile.desktop"
      nixos."gui.nvidia"
      ./hardware-configuration.nix
      {
        people.primaryUser = "mori";
        networking.hostName = "Mori-Laptop-NixOS";

        people.home.imports = [
          home."profile.desktop"
        ];
      }
    ];
  };
}
