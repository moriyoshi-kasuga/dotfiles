{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.sv-main = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.base
      nixos.server
      ./_hardware-configuration.nix
      {
        people.primaryUser = "sv-main";
        people.flakeHost = "sv-main";
        networking.hostName = "sv-main";

        people.home.imports = [
          home."lang.c"
        ];
      }
    ];
  };
}
