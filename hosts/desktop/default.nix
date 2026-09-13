{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
  home = inputs.self.modules.homeManager;

  monospaceFont = "monaspace-neon";
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos."host.desktop"
      nixos."gui.amd"
      nixos."gui.claude-desktop"
      ./hardware-configuration.nix
      (
        { pkgs, ... }:
        {
          people.primaryUser = "mori";
          networking.hostName = "Mori-NixOS";
          users.users.mori.shell = pkgs.fish;

          # RDNA4 dGPU (RX 9060 XT) is new hardware; keep firmware/microcode
          # blobs up to date to reduce amdgpu instability (fence timeouts).
          hardware.enableRedistributableFirmware = true;

          modules.font.monospace = monospaceFont;

          home-manager.users.mori = {
            home.username = "mori";
            home.homeDirectory = "/home/mori";
            modules.font.monospace = monospaceFont;
            imports = [
              home."profile.desktop"
            ];
          };
        }
      )
    ];
  };
}
