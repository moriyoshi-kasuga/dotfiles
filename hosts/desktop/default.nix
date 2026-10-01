{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
  home = inputs.self.modules.homeManager;
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos."profile.desktop"
      nixos."gui.amd"
      nixos."gui.claude-desktop"
      ./hardware-configuration.nix
      {
        people.primaryUser = "mori";
        networking.hostName = "Mori-NixOS";

        # RDNA4 dGPU (RX 9060 XT) is new hardware; keep firmware/microcode
        # blobs up to date to reduce amdgpu instability (fence timeouts).
        hardware.enableRedistributableFirmware = true;

        modules.font.monospace = "monaspace-neon";

        people.home.imports = [
          home."profile.desktop"
        ];
      }
    ];
  };
}
