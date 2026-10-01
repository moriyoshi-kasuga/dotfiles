{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
  home = inputs.self.modules.homeManager;
in
{
  flake.nixosConfigurations.sv-main = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos."profile.base"
      ./hardware-configuration.nix
      {
        people.primaryUser = "sv-main";
        networking.hostName = "sv-main";

        services.tailscale.extraSetFlags = [ "--ssh" ];
        security.pam.services.remote = { };

        people.home.imports = [
          home."profile.core"
          home."lang.c"
        ];

        systemd.targets.sleep.enable = false;
        systemd.targets.suspend.enable = false;
        systemd.targets.hibernate.enable = false;
        systemd.targets.hybrid-sleep.enable = false;
      }
    ];
  };
}
