{
  mkModule,
  pkgs,
  username,
  ...
}:

mkModule {
  name = "nixos.gui.brave";
  inheritModule = "nixos.gui";
  nixosModule = {
    users.users.${username}.packages = [
      pkgs.brave
    ];

    xdg.mime.defaultApplications = {
      "text/html" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
    };
  };
}
