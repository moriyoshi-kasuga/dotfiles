_:

{
  flake.modules.nixos.network = {
    services.resolved.enable = true;

    networking = {
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
