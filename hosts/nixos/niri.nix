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

    # Launcher
    fuzzel

    # Screen locker
    hyprlock

    # XDG Portals (スクリーンキャスト、ファイル選択等に必要)
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk

    (xwayland-satellite.override { withSystemd = false; }) # Niri automatically runs this when xwayland support is required

    # Screenshot utilities (niriには内蔵されているが、追加ツールも有用)
    grim
    slurp

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

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
  };

  programs = {
    niri = {
      enable = true;
    };

    hyprlock = {
      enable = true;
    };

    # Xwaylandのサポート (xwayland-satellite経由)
    xwayland = {
      enable = true;
    };
  };

  i18n.inputMethod.fcitx5.waylandFrontend = true;

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
