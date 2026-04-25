{
  mkModule,
  ...
}:

mkModule {
  name = "nixos.tailscale";
  inheritModule = "nixos";
  nixosModule = {
    services.tailscale.enable = true;

    networking = {
      firewall = {
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ 41641 ];
      };
    };
  };
}
