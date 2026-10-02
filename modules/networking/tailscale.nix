_:

{
  flake.modules.nixos.base = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };

  flake.modules.darwin.base = {
    services.tailscale.enable = true;
  };
}
