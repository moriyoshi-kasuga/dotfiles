{ inputs, ... }:

let
  # FIXME:
  # xwayland-satellite 0.8.2 closes Steam's dropdown menus right after they
  # open (https://github.com/Supreeeme/xwayland-satellite/issues/156), so pin it to 0.8.1.
  # Drop this and the flake input once a fixed release lands in nixpkgs.
  xwaylandSatellitePinOverlay = _final: prev: {
    inherit
      (import inputs.nixpkgs-xwayland-satellite-pin { inherit (prev.stdenv.hostPlatform) system; })
      xwayland-satellite
      ;
  };

  # config.kdl が config/*.kdl を include する
  includedConfigs = [
    "misc"
    "input"
    "output"
    "layout"
    "windows"
    "layers"
    "binds"
  ];

  home = {
    home.file = {
      ".config/niri/config.kdl" = {
        source = ./config.kdl;
        force = true;
      };
    }
    // builtins.listToAttrs (
      map (name: {
        name = ".config/niri/config/${name}.kdl";
        value = {
          source = ./. + "/${name}.kdl";
          force = true;
        };
      }) includedConfigs
    );
  };
in
{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      people.home.imports = [ home ];

      nixpkgs.overlays = [ xwaylandSatellitePinOverlay ];

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
