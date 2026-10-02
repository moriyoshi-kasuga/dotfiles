_:

{
  flake.modules.nixos.base = {
    services.openssh = {
      enable = true;
      # tailscale0 は trustedInterfaces なので、tailnet 経由でだけ届くようにする
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
