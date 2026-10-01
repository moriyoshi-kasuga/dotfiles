_:

{
  # 画面を持たず常時稼働させる host 向け
  flake.modules.nixos.server = {
    services.tailscale.extraSetFlags = [ "--ssh" ];
    security.pam.services.remote = { };

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
  };
}
