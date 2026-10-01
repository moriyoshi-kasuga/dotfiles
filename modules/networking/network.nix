_:

{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      services.resolved.enable = true;
      services.resolved.settings.Resolve.DNSOverTLS = "opportunistic";

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

      environment.systemPackages = [ pkgs.ethtool ];

      # r8169 (Realtek RTL8111/8125) drops/renegotiates the link under EEE
      # power saving; disable it on interfaces using that driver.
      # Use $name (the post-rename interface name) rather than
      # $env{INTERFACE} (the pre-rename kernel name, e.g. eth0): by the time
      # RUN+= actually executes, udev has already renamed the interface, so
      # $env{INTERFACE} points at a device that no longer exists.
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", DRIVERS=="r8169", RUN+="${pkgs.ethtool}/bin/ethtool --set-eee $name eee off"
      '';

      # BBR handles loss/jitter on the last-mile link far better than cubic,
      # and cake keeps latency low under load (bufferbloat) without needing
      # a manually tuned bandwidth shaper.
      boot.kernelModules = [ "tcp_bbr" ];
      boot.kernel.sysctl = {
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";

        # The 4MB defaults cap SO_RCVBUF/SO_SNDBUF for QUIC and tailscale's
        # UDP sockets, and the tcp_wmem ceiling limits uploads over
        # high-RTT (overseas) paths. tcp_rmem's ceiling is already 32MB.
        "net.core.rmem_max" = 16777216;
        "net.core.wmem_max" = 16777216;
        "net.ipv4.tcp_wmem" = "4096 16384 16777216";
        # IPv4 goes through IPv4-over-IPv6 (path MTU 1460); recover from
        # PMTU blackholes instead of stalling.
        "net.ipv4.tcp_mtu_probing" = 1;
        # Keep the cwnd of idle long-lived connections (HTTP/2 etc.).
        "net.ipv4.tcp_slow_start_after_idle" = 0;
      };
    };
}
