{
  pkgs,
  inputs,
  vars,
  ...
}:

{
  # niriに必要な基本パッケージ
  environment.systemPackages = with pkgs; [
    # Core
    wayland
    niri

    # Additional packages for better experience
    qimgv # image viewer
    mpv # media player

    grim
    slurp

    (xwayland-satellite.override { withSystemd = false; }) # Niri automatically runs this when xwayland support is required

    gtk4
    gtk4-layer-shell
    quickshell
  ];

  home-manager.users.${vars.username} = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    # configure options
    programs.noctalia-shell = {
      enable = true;
      settings = {
        # configure noctalia here
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "WiFi";
              }
              {
                id = "Bluetooth";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                id = "Volume";
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "NotificationHistory";
              }
            ];
          };
        };
        dock = {
          enabled = false;
        };
        network = {
          wifiEnabled = false;
        };
        appLauncher = {
          terminalCommand = "wezterm -e";
        };
        general = {
          enableShadows = false;
        };
        ui = {
          fontDefault = "CommitMono Nerd Font";
          fontFixed = "CommitMono Nerd Font";
        };
      };
    };
  };

  environment.sessionVariables = {
    # Wayland 設定
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";

    # NVIDIA Wayland サポート
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  programs = {
    niri = {
      enable = true;
    };

    # Xwaylandのサポート (xwayland-satellite経由)
    xwayland = {
      enable = true;
    };
  };

  # XDG Desktop Portal の設定
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
      };
    };
  };

  services = {
    # D-Bus (必須)
    dbus.enable = true;
  };
}
