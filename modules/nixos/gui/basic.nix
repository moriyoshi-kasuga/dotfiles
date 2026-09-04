_:

{
  flake.modules.nixos."gui.basic" = {
    catppuccin.cursors.enable = true;

    xdg.mime.enable = true;

    services.libinput.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;

    services.power-profiles-daemon.enable = true;
    powerManagement.enable = true;

    services.logind.settings.Login = {
      HandlePowerKey = "hibernate";
      HandlePowerKeyLongPress = "poweroff";
      HandleSuspendKey = "suspend";
      HandleHibernateKey = "hibernate";
      HandleLidSwitch = "suspend-then-hibernate";
    };

    # HibernateDelaySec belongs to sleep.conf's [Sleep] section, not
    # logind.conf's [Login] section (systemd silently ignores it there).
    systemd.sleep.settings.Sleep.HibernateDelaySec = 3600;

    security.polkit.enable = true;
  };
}
