_:

{
  flake.modules.nixos.network =
    { pkgs, ... }:
    {
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

      # r8169 (Realtek RTL8111/8125) drops/renegotiates the link under EEE
      # power saving; disable it on interfaces using that driver.
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", DRIVERS=="r8169", RUN+="${pkgs.ethtool}/bin/ethtool --set-eee $env{INTERFACE} eee off"
      '';
    };
}
