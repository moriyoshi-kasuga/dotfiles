{ inputs, ... }:

{
  flake.modules.homeManager."gui.niri" = {
    home.file = {
      ".config/niri/config.kdl" = {
        source = ./niri/config.kdl;
        force = true;
      };
      ".config/niri/config/misc.kdl" = {
        source = ./niri/misc.kdl;
        force = true;
      };
      ".config/niri/config/input.kdl" = {
        source = ./niri/input.kdl;
        force = true;
      };
      ".config/niri/config/output.kdl" = {
        source = ./niri/output.kdl;
        force = true;
      };
      ".config/niri/config/layout.kdl" = {
        source = ./niri/layout.kdl;
        force = true;
      };
      ".config/niri/config/windows.kdl" = {
        source = ./niri/windows.kdl;
        force = true;
      };
      ".config/niri/config/layers.kdl" = {
        source = ./niri/layers.kdl;
        force = true;
      };
      ".config/niri/config/binds.kdl" = {
        source = ./niri/binds.kdl;
        force = true;
      };
    };

    programs.noctalia = {
      enable = true;
      settings = {
        bar.widgets.enabled = false;
        dock.enabled = false;
        weather.enabled = true;

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

        control_center = {
          sidebar = "none";
          sidebar_section = "none";
        };

        osd.kinds = {
          keyboard_layout = false;
          media = false;
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

  flake.modules.nixos."gui.niri" =
    { pkgs, ... }:
    {
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
