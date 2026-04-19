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
    imv
    mpv
    grim
    slurp
    xwayland-satellite
    libnotify
    mako
  ];

  environment.sessionVariables = {
    # Input Method
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "fcitx";
    SDL_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";

    # Qt settings
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

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

    # NVIDIA
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    # Fix for hardware video acceleration with NVIDIA
    NVD_BACKEND = "direct";
    # Sometimes needed for cursor on NVIDIA
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  qt = {
    enable = true;
    style = "kvantum";
    platformTheme = "qt5ct";
  };

  programs.dconf.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
      ];
      settings = {
        globalOptions = {
          "Hotkey" = {
            TriggerKeys = "";
          };
          "Hotkey/ActivateKeys" = {
            "0" = "Alt+Alt_R";
          };
          "Hotkey/DeactivateKeys" = {
            "0" = "Alt+Alt_L";
          };
        };
        inputMethod = {
          GroupOrder = {
            "0" = "Default";
          };
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
        };
      };
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
      };
    };
  };

  services.dbus.enable = true;

  home-manager.users.${username} = {
    imports = [ inputs.noctalia.homeModules.default ];

    catppuccin.kvantum.enable = true;

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Papirus-Dark";
      };
    };

    xdg.configFile."qt5ct/qt5ct.conf".text = ''
      [Appearance]
      style=kvantum
      icon_theme=Papirus-Dark

      [Interface]
      buttonbox_layout=0
      menus_have_icons=true
      toolbutton_style=4
    '';
    xdg.configFile."qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=kvantum
      icon_theme=Papirus-Dark

      [Interface]
      buttonbox_layout=0
      menus_have_icons=true
      toolbutton_style=4
    '';
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
        network = {
          wifiEnabled = true;
        };
        appLauncher = {
          terminalCommand = "wezterm -e";
          showCategories = false;
          enableSettingsSearch = false;
          enableWindowsSearch = false;
          enableSessionSearch = false;
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
