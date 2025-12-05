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

    # XDG Portals (スクリーンキャスト、ファイル選択等に必要)
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk

    # Additional packages for better experience
    qimgv # image viewer
    mpv # media player

    (xwayland-satellite.override { withSystemd = false; }) # Niri automatically runs this when xwayland support is required

    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.${vars.username} = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
    };
  };

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gnome";
  };

  environment.sessionVariables = {
    # Wayland 設定
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gnome";
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
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  services = {
    # D-Bus (必須)
    dbus.enable = true;
  };
}
