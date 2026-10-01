_:

let
  home = {
    home.file.".config/brave-flags.conf".text = ''
      --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder
      --ozone-platform=wayland
      --disable-gpu-compositing
    '';
  };
in
{
  flake.modules.nixos.pc =
    { pkgs, config, ... }:
    {
      people.home.imports = [ home ];

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
