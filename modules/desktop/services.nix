_:

{
  flake.modules.nixos.pc = {
    xdg.mime.enable = true;

    services.libinput.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;

    services.power-profiles-daemon.enable = true;
    powerManagement.enable = true;

    services.gnome.gnome-keyring.enable = true;

    # 電源キーの短押しは host ごとに決める (hibernate できるかは swap 次第)
    services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";

    security.polkit.enable = true;

    # Under sustained memory pressure, kill the heaviest unit in the user
    # slice before the kernel OOM killer thrashes. noctalia launches apps as
    # their own units, so a single app gets picked instead of the whole shell.
    systemd.oomd.enableUserSlices = true;
  };
}
