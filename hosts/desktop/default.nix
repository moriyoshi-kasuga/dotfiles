{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos.pc
      nixos.amd
      nixos.claude-desktop
      ./_hardware-configuration.nix
      {
        people.primaryUser = "mori";
        networking.hostName = "Mori-NixOS";

        # RDNA4 dGPU (RX 9060 XT) is new hardware; keep firmware/microcode
        # blobs up to date to reduce amdgpu instability (fence timeouts).
        hardware.enableRedistributableFirmware = true;

        style.fonts.monospace = "monaspace-neon";

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
