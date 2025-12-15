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

    gtk4
    gtk4-layer-shell
  ];

  home-manager.users.${vars.username} = {
    programs.sherlock = {
      enable = true;
      systemd.enable = true;

      # If wanted, you can use this line for the _latest_ package. / Otherwise, you're relying on nixpkgs to update it frequently enough.
      # For this to work, make sure to add sherlock as a flake input!
      # package = inputs.sherlock.packages.${pkgs.system}.default;

      # config.toml
      settings = {
        default_apps = {
          terminal = "wezterm";
        };
      };

      # sherlockignore
      ignore = ''
        Avahi*
      '';
    };
  };

  environment.sessionVariables = {
    # Wayland 設定
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk4";
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
    config = {
      common = {
        default = [
          "gtk4"
        ];
      };
      niri = {
        default = [
          "gtk4"
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
