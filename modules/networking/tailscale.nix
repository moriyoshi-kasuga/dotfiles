_:

{
  flake.modules.nixos.base = {
    services.tailscale.enable = true;

    networking = {
      firewall = {
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ 41641 ];
      };
    };
  };

  flake.modules.darwin.base = {
    services.tailscale.enable = true;
  };
}
