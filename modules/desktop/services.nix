_:

{
  flake.modules.nixos.pc = {
    services.libinput.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;

    services.power-profiles-daemon.enable = true;

    services.gnome.gnome-keyring.enable = true;

    # 電源キーの短押しは host ごとに決める (hibernate できるかは swap 次第)
    services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";

    security.polkit.enable = true;

    # Under sustained memory pressure, kill the heaviest unit in the user
    # slice before the kernel OOM killer thrashes. noctalia launches apps as
    # their own units, so a single app gets picked instead of the whole shell.
    systemd.oomd.enableUserSlices = true;

    # The 90s default lets a single hung user process (e.g. a stale
    # mozc_server left in a tmux scope) hold up logout and shutdown for the
    # full timeout. Desktop apps that exit cleanly do so well within this.
    systemd.user.settings.Manager.DefaultTimeoutStopSec = "15s";
  };
}
