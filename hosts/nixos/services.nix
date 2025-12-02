{ config, ... }:

{
  # OpenSSH
  services.openssh.enable = true;

  # プリンター (CUPS)
  services.printing.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;

  # ファイアウォール設定
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
