{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
  home = inputs.self.modules.homeManager;
in
{
  flake.nixosConfigurations.laptop-nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos."host.desktop"
      nixos."gui.nvidia"
      ./hardware-configuration.nix
      (
        { pkgs, ... }:
        {
          people.primaryUser = "mori";
          networking.hostName = "Mori-Laptop-NixOS";
          users.users.mori.shell = pkgs.fish;

          home-manager.users.mori = {
            home.username = "mori";
            home.homeDirectory = "/home/mori";
            imports = [
              home."profile.desktop"
            ];
          };
        }
      )
    ];
  };
}
