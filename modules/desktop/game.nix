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
        modrinth-app
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
