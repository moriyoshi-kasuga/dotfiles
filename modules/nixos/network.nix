{
  mkModule,
  lib,
  ...
}:

mkModule {
  name = "nixos.network";
  inheritModule = "nixos";
  options = {
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "NixOS's HostName";
    };
  };
  nixosModule =
    { cfg, ... }:
    {
      services.resolved.enable = true;

      networking = {
        hostName = cfg.hostName;
        nameservers = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        networkmanager = {
          enable = true;
          dns = "systemd-resolved";
        };
        firewall.enable = true;
      };
    };
}
