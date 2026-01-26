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
    gtk4
    gtk4-layer-shell
    quickshell
  ];

  environment.sessionVariables = {
    # Wayland Common
    QT_QPA_PLATFORM = "wayland;xcb";
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

    # Input Method
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
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
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              { id = "WiFi"; }
              { id = "Bluetooth"; }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              { id = "Volume"; }
              {
                formatHorizontal = "HH:mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              { id = "NotificationHistory"; }
            ];
          };
        };
        appLauncher.terminalCommand = "wezterm -e";
        ui = {
          fontDefault = "CommitMono Nerd Font";
          fontFixed = "CommitMono Nerd Font";
        };
      };
    };
  };
}

