{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.sv-main = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos.base
      nixos.server
      ./hardware-configuration.nix
      {
        people.primaryUser = "sv-main";
        networking.hostName = "sv-main";

        people.home.imports = [
          home."lang.c"
        ];
      }
    ];
  };
}
