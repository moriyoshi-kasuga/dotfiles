{
  pkgs,
  inputs,
  username,
  ...
}:

{
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    wayland
    niri
    qimgv
    mpv
    grim
    slurp
    (xwayland-satellite.override { withSystemd = false; })
    quickshell
    libnotify
    mako
    qt6Packages.qt6ct
  ];

  environment.sessionVariables = {
    # Input Method
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "wayland;fcitx";
    QT_IM_MODULES = "wayland;fcitx"; # Qt6

    # Qt settings
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # Wayland Common
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    CLUTTER_BACKEND = "wayland";

    # Chromium / Electron
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    # NVIDIA
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  qt = {
    enable = true;
    style = "adwaita";
    platformTheme = "gnome";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
      ];
    };
  };
  catppuccin.fcitx5.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };
  catppuccin.sddm = {
    enable = true;
    flavor = "mocha";
    accent = "sapphire";
    font = "JetBrains Mono";
    fontSize = "10";
    loginBackground = true;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      serif = [
        "Noto Serif CJK JP"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans CJK JP"
        "Noto Color Emoji"
      ];
      monospace = [ "JetBrains Mono" ];
    };
  };

  xdg.portal = {
    enable = true;
    # Niri は独自の portal を持たないため、適切な fallback を設定
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      niri.default = [
        "gnome"
        "gtk"
      ];
    };
  };

  services.dbus.enable = true;

  home-manager.users.${username} = {
    imports = [ inputs.noctalia.homeModules.default ];
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "compact";
          position = "top";
          displayMode = "auto_hide";
          useSeparateOpacity = true;
          backgroundOpacity = 0.2;
          showCapsule = true;
          capsuleOpacity = 1;
          showOutline = false;
          floating = false;
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
                labelMode = "none";
              }
            ];
            right = [
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
        colorSchemes = {
          predefinedScheme = "Catppuccin";
        };
        general = {
          enableShadows = false;
          dimmerOpacity = 0.2;
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
              id = "media-sysmon-card";
            }
          ];
        };
        dock = {
          enabled = false;
        };
        appLauncher = {
          terminalCommand = "wezterm -e";
          showCategories = false;
          enableSettingsSearch = false;
        };
        notifications = {
          sounds = {
            enabled = true;
          };
        };
        location = {
          name = "Tokyo";
          weatherEnabled = false;
        };
        ui = {
          fontDefault = "CommitMono Nerd Font";
          fontFixed = "CommitMono Nerd Font";
        };
      };
    };
  };
}
