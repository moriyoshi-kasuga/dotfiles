_:

{
  flake.modules.nixos.game =
    {
      config,
      pkgs,
      ...
    }:
    {
      users.users.${config.people.primaryUser}.extraGroups = [
        "gamemode"
      ];

      environment.systemPackages = with pkgs; [
        r2modman
        # FIXME: temporary patch for modrinth-app
        # sqlx-macros links against the system libsqlite3, but nixpkgs does not
        # put sqlite in buildInputs, so the build fails with "cannot find -lsqlite3".
        (modrinth-app.override {
          modrinth-app-unwrapped = modrinth-app-unwrapped.overrideAttrs (old: {
            buildInputs = old.buildInputs ++ [ sqlite ];
          });
        })
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
      programs.gamemode.enable = true;
    };
}
