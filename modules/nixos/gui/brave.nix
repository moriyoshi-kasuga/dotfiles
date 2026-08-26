_:

{
  flake.modules.homeManager."gui.brave" = {
    home.file.".config/brave-flags.conf".text = ''
      --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder
      --ozone-platform=wayland
      --disable-gpu-compositing
    '';
  };

  flake.modules.nixos."gui.brave" =
    { pkgs, config, ... }:
    {
      users.users.${config.people.primaryUser}.packages = [
        pkgs.brave
      ];

      xdg.mime.defaultApplications = {
        "text/html" = [ "brave.desktop" ];
        "x-scheme-handler/http" = [ "brave.desktop" ];
        "x-scheme-handler/https" = [ "brave.desktop" ];
      };
    };
}
