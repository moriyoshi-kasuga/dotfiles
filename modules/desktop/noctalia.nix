{ inputs, ... }:

let
  home =
    { osConfig, ... }:
    {
      programs.noctalia = {
        enable = true;
        # graphical-session.target に紐づく user service にして、落ちたら再起動させる。
        # spawn-at-startup だと再起動されず、ロック中に落ちると復帰できない。
        systemd.enable = true;
        settings = {
          bar.widgets.enabled = false;
          dock.enabled = false;
          weather.enabled = false;

          shell = {
            font_family = osConfig.style.fonts.monospaceFont.family;

            # ランチャーから起動したアプリを noctalia の scope ではなく
            # app-<id>@<uuid>.service として起動する。noctalia の再起動や
            # OOM kill にアプリが巻き込まれず、oomd もアプリ単位で選べる。
            launch_apps_as_systemd_services = true;

            # 他に polkit エージェントがないので、GUI からの権限要求を受ける
            polkit_agent = true;

            panel = {
              borders = true;
            };

            launcher = {
              categories = false;
              compact = true;
              layout = "simple";
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
  # noctalia 本体は homeModules.default が programs.noctalia.package として入れる
  flake.modules.nixos.pc = {
    people.home.imports = [
      inputs.noctalia.homeModules.default
      home
    ];

    security.pam.services.noctalia = { };
  };
}
