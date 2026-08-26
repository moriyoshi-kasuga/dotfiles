_:

{
  flake.modules.nixos."gui.thunar" =
    { pkgs, ... }:
    {
      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
      programs.xfconf.enable = true;
      services.gvfs.enable = true;
      services.tumbler.enable = true;

      xdg.mime.defaultApplications."inode/directory" = [ "thunar.desktop" ];
    };
}
