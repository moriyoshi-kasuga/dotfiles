{
  mkModule,
  username,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.base";
  module = {
    home-manager.backupFileExtension = "nixbackup";
    system.stateVersion = "26.05";

    users.users.${username} = {
      isNormalUser = true;
      description = username;
      group = username;
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "audio"
        "video"
      ];
      packages = with pkgs; [
        wl-clipboard
      ];
    };
  };
}
