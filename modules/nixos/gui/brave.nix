{
  mkModule,
  pkgs,
  username,
  ...
}:

mkModule {
  name = "nixos.gui.brave";
  inheritModule = "nixos.gui";
  linuxHomeModule = {
    home.file.".config/brave-flags.conf".text = ''
      --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder
      --ozone-platform=wayland
      --disable-gpu-compositing
    '';
  };
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
