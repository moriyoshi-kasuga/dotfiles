{
  mkModule,
  username,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.gui.zed";
  inheritModule = "nixos.gui";
  nixosModule = {
    users.users.${username} = {
      packages = with pkgs; [
        zed-editor-fhs
      ];
    };
  };
}
