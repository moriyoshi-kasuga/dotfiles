{
  vars,
  ...
}:

{
  # Steam ゲーミングプラットフォーム
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  users.users.${vars.username} = {
    extraGroups = [
      "gamemode"
    ];
  };
}
