{
  mkModule,
  username,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.gui.game";
  inheritModule = "nixos.gui";
  nixosModule = {
    users.users.${username} = {
      extraGroups = [
        "gamemode"
      ];
      packages = with pkgs; [
        discord
        appimage-run
        r2modman
        # modrinth-app: upstream postBuild misuses `wrapGAppsHook` as a
        # command; fix not yet merged, so patch it here as a stopgap.
        # symlinkJoin folds postBuild into buildCommand, so patch that instead.
        (modrinth-app.overrideAttrs (old: {
          buildCommand =
            lib.replaceStrings
              [ "wrapGAppsHook" ]
              [
                ''wrapGApp "$out/bin/ModrinthApp"''
              ]
              old.buildCommand;
        }))
      ];
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      # DRI_PRIME=1 (see hosts/desktop/hardware-configuration.nix) makes
      # steamwebhelper segfault on startup, so drop it inside Steam's FHS env.
      package = pkgs.steam.override {
        extraProfile = ''
          unset DRI_PRIME
        '';
      };
    };
    programs.gamemode.enable = true;
  };
}
