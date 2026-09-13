_:

{
  flake.modules.nixos.peripherals =
    { pkgs, ... }:
    {
      # systemd's default hidraw uaccess rules only cover a narrow
      # allowlist (AV controllers, lights, hardware wallets, 3D mice) as
      # an anti-keylogging measure, so generic keyboards stay root-only
      # under /dev/hidraw*. That blocks browser-based configurators
      # (WebHID) from ever getting a response, which some of them
      # surface as the device being "asleep" rather than a permission
      # error.
      #
      # ATK68 V2 S (Shenzhen Yizhita), used with the atkhub web
      # configurator via Brave/WebHID.
      #
      # This must ship as its own rules file sorted before systemd's
      # 73-seat-late.rules (which is what actually grants the ACL for
      # anything tagged "uaccess"), rather than via services.udev.extraRules
      # (fixed at 99-local.rules, evaluated after 73). Tagging a device
      # after 73 already ran is one file too late: the tag lands in the
      # udev DB but no ACL ever gets applied. Calling the uaccess builtin
      # ourselves isn't an option either — modern systemd only allows its
      # own shipped rules to invoke it.
      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "atk68-v2s-udev-rules";
          destination = "/etc/udev/rules.d/70-atk68-v2s.rules";
          text = ''
            SUBSYSTEM=="hidraw", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="10c2", TAG+="uaccess"
          '';
        })
      ];
    };
}
