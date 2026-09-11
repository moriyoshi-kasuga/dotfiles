_:

{
  flake.modules.nixos."gui.greetd" =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.niri}/bin/niri-session";
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
