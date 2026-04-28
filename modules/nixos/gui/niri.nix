{
  mkModule,
  pkgs,
  lib,
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

    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "default";
          position = "top";
          displayMode = "auto_hide";
          useSeparateOpacity = true;
          backgroundOpacity = 0.6;
          showCapsule = true;
          showOutline = false;
          showOnWorkspaceSwitch = false;
          capsuleOpacity = 0.8;
          autoHideDelay = 150;
          autoShowDelay = 500;
          floating = true;
          marginVertical = 4;
          marginHorizontal = 4;
          frameRadius = 16;
          frameThickness = 2;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              { id = "Bluetooth"; }
            ];
            center = [
              {
                id = "Workspace";
                hideUnoccupied = false;
                labelMode = "index";
              }
            ];
            right = [
              { id = "SystemMonitor"; }
              {
                id = "Volume";
                displayMode = "alwaysShow";
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - dd MM";
                tooltipFormat = "HH:mm ddd, MMM dd";
              }
              { id = "NotificationHistory"; }
            ];
          };
        };
        wallpaper = {
          enabled = true;
          overviewEnabled = true;
          automationEnabled = false;
        };
        colorSchemes = {
          predefinedScheme = "Catppuccin";
        };
        general = {
          enableShadows = true;
          dimmerOpacity = 0.3;
          shadowDirection = "bottom";
          boxBorderEnabled = true;
        };
        controlCenter = {
          position = "top_center";
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        dock = {
          enabled = false;
        };
        network = {
          wifiEnabled = true;
        };
        appLauncher = {
          terminalCommand = "wezterm -e";
          showCategories = false;
          enableSettingsSearch = false;
          enableWindowsSearch = false;
          enableSessionSearch = false;
          iconMode = "tabler";
        };
        notifications = {
          sounds = {
            enabled = true;
          };
          enableBatteryToast = true;
          enableKeyboardLayoutToast = false;
          enableMediaToast = false;
        };
        location = {
          name = "Tokyo";
          weatherEnabled = true;
          autoLocate = true;
        };
        ui = {
          fontDefault = "JetBrains Mono Nerd Font";
          fontFixed = "JetBrains Mono Nerd Font";
          borderRadius = 16;
        };
      };
    };
  };
  nixosModule = {
    programs.niri.enable = true;
    programs.xwayland.enable = true;
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
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
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gnome
      ];
      config = {
        common = {
          default = [ "wlr" ];
        };
        niri = {
          default = lib.mkForce [
            "wlr"
          ];
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
