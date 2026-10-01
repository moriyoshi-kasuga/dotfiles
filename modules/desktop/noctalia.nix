{ inputs, ... }:

let
  home =
    { osConfig, ... }:
    {
      programs.noctalia = {
        enable = true;
        settings = {
          bar.widgets.enabled = false;
          dock.enabled = false;
          weather.enabled = false;

          shell = {
            font_family = osConfig.style.fonts.monospaceFamily;

            panel = {
              borders = true;
            };

            launcher = {
              categories = false;
            };

            shadow = {
              direction = "down";
            };
          };

          control_center = {
            sidebar = "none";
            sidebar_section = "none";
          };

          osd.kinds = {
            keyboard_layout = false;
            media = false;
          };

          theme = {
            source = "builtin";
            builtin = "Catppuccin";
          };

          wallpaper = {
            enabled = true;
            automation = {
              enabled = false;
            };
          };

          location = {
            auto_locate = true;
            address = "Tokyo";
          };

          audio = {
            enable_sounds = true;
          };
        };
      };
    };
in
{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      people.home.imports = [
        inputs.noctalia.homeModules.default
        home
      ];

      security.pam.services.noctalia = { };

      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
