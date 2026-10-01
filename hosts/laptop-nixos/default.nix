{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.laptop-nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos.pc
      nixos.nvidia
      ./_hardware-configuration.nix
      {
        people.primaryUser = "mori";
        networking.hostName = "Mori-Laptop-NixOS";

        hardware.nvidia.prime = {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };

        people.home.imports = [
          home."lang.buf"
          home."lang.c"
          home."lang.go"
          home."lang.haskell"
          home."lang.jvm"
          home."lang.lua"
          home."lang.node"
          home."lang.python"
          home."lang.rust"
          home."lang.wasm"
        ];
      }
    ];
  };
}
