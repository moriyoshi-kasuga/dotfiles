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
        modrinth-app
      ];
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.gamemode.enable = true;
  };
}
