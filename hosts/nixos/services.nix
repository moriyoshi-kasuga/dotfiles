{ config, ... }:

{
  services = {
    # OpenSSH
    openssh.enable = true;

    # プリンター (CUPS)
    printing.enable = true;

    # Tailscale VPN
    tailscale.enable = true;
  };

  # ファイアウォール設定
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
