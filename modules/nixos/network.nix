{
  mkModule,
  username,
  ...
}:

mkModule {
  name = "nixos.network";
  inheritModule = "nixos";
  nixosModule = {
    services.resolved.enable = true;

    networking = {
      hostName = "${username}-NixOS";
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
