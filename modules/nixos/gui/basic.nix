{
  mkModule,
  ...
}:

mkModule {
  name = "nixos.gui.basic";
  inheritModule = "nixos.gui";
  nixosModule = {
    catppuccin.cursors.enable = true;

    xdg.mime.enable = true;

    services.libinput.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;

    services.power-profiles-daemon.enable = true;
    powerManagement.enable = true;

    services.logind.settings.Login = {
      HandlePowerKey = "ignore";
      LidSwitch = "suspend-then-hibernate";
      PowerKey = "hibernate";
      PowerKeyLongPress = "poweroff";
    };

    security.polkit.enable = true;
  };
}
