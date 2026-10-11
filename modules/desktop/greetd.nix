_:

{
  flake.modules.nixos.pc =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      systemctl = "${config.systemd.package}/bin/systemctl";
    in
    {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session = {
          command = lib.escapeShellArgs [
            (lib.getExe pkgs.tuigreet)
            "--time"
            "--remember"
            # The default `shutdown` needs root and fails as the greeter user;
            # logind allows it for the active local session via polkit.
            "--power-shutdown"
            "${systemctl} poweroff"
            "--power-reboot"
            "${systemctl} reboot"
            # greetd puts these into PAM before open_session, so logind also
            # records the session as wayland. Setting them globally via
            # environment.sessionVariables would leak into ssh/tty sessions.
            "--env"
            "XDG_SESSION_TYPE=wayland"
            "--env"
            "XDG_SESSION_DESKTOP=niri"
            "--env"
            "XDG_CURRENT_DESKTOP=niri"
            # niri-session runs `systemctl --user import-environment` without
            # arguments, which prints a yellow deprecation warning on the tty
            # right after login. Send the session's output to the journal
            # instead (`journalctl -t niri-session`).
            "--cmd"
            "${config.systemd.package}/bin/systemd-cat -t niri-session --stderr-priority=warning ${config.programs.niri.package}/bin/niri-session"
          ];
          user = "greeter";
        };
      };

      # Without this, gnome-keyring never receives the login password
      # from PAM, so it can't auto-unlock at login ("gkr-pam: unable to
      # locate daemon control file") and ends up spawning a second,
      # unusable daemon instance in the session.
      security.pam.services.greetd.enableGnomeKeyring = true;
    };
}
