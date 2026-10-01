_:

{
  flake.modules.nixos.pc =
    {
      config,
      pkgs,
      ...
    }:
    {
      users.users.${config.people.primaryUser} = {
        extraGroups = [
          "gamemode"
        ];
        packages = with pkgs; [
          discord
          appimage-run
          r2modman
          modrinth-app
        ];
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        # DRI_PRIME=1 (see hosts/desktop/_hardware-configuration.nix) makes
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
