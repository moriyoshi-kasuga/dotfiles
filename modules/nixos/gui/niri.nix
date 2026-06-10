{
  mkModule,
  pkgs,
  inputs,
  ...
}:

mkModule {
  name = "nixos.gui.niri";
  inheritModule = "nixos.gui";
  linuxHomeModule = {
    home.file.".config/niri/config.kdl" = {
      source = ./niri.kdl;
      force = true;
    };

    programs.noctalia = {
      enable = true;
      settings = {
        shell = {
          font_family = "JetBrains Mono Nerd Font";

          panel = {
            borders = true;
            launcher_categories = false;
          };

          shadow = {
            direction = "down";
          };
        };

        bar = {
          order = [ "widgets" ];
          widgets = {
            position = "top";
            auto_hide = true;
            reserve_space = false;
            background_opacity = 0.6;
            capsule = true;
            capsule_opacity = 0.8;
            radius = 16;
            margin_edge = 4;
            margin_ends = 4;

            start = [
              "control-center"
              "bluetooth"
            ];
            center = [ "workspaces" ];
            end = [
              "cpu"
              "ram"
              "volume"
              "clock"
              "notifications"
            ];
          };
        };

        widget = {
          clock = {
            type = "clock";
            format = "{:%H:%M %a, %b %d}";
            vertical_format = "{:%H %M - %d %m}";
            tooltip_format = "{:%H:%M %a, %b %d}";
          };
          cpu = {
            type = "sysmon";
            stat = "cpu_usage";
          };
          ram = {
            type = "sysmon";
            stat = "ram_used";
          };
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

        dock = {
          enabled = false;
        };

        weather = {
          enabled = true;
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
  nixosModule = {
    programs.niri.enable = true;
    programs.xwayland.enable = true;
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

      wayland
      niri
      imv
      mpv
      grim
      slurp
      xwayland-satellite
      libnotify
      mako
    ];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "gtk" ];
        };
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        };
      };
    };

    environment.sessionVariables = {
      # Wayland Common
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      CLUTTER_BACKEND = "wayland";

      # Chromium / Electron / Firefox
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
