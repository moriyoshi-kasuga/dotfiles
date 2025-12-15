{
  pkgs,
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

  users.users.${vars.username} = {
    extraGroups = [
      "gamemode"
    ];
    packages = with pkgs; [
      gamemode
    ];
  };
}
