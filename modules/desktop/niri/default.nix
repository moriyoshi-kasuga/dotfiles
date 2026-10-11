{ inputs, ... }:

let
  # FIXME:
  # xwayland-satellite 0.8.2 closes Steam's dropdown menus right after they
  # open (https://github.com/Supreeeme/xwayland-satellite/issues/156), so pin it to 0.8.1.
  # Drop this and the flake input once a fixed release lands in nixpkgs.
  #
  # Only the satellite itself is pinned. The pinned nixpkgs' Xwayland is built
  # against an older glibc than the system mesa in /run/opengl-driver, so it
  # cannot load the GPU driver: glamor falls back to software rendering, DRI3
  # disappears, and Vulkan games under Proton exit at startup with
  # "No DRI3 support detected".
  xwaylandSatellitePinOverlay = _final: prev: {
    xwayland-satellite =
      (import inputs.nixpkgs-xwayland-satellite-pin {
        inherit (prev.stdenv.hostPlatform) system;
      }).xwayland-satellite.override
        { inherit (prev) xwayland; };
  };

  # config.kdl はこの順に config/*.kdl を include する。
  # 後の include ほど優先されるので、ホスト固有の設定 (host.kdl) は最後に置く。
  sharedConfigs = [
    "misc"
    "input"
    "layout"
    "windows"
    "layers"
    "binds"
  ];
in
{
  flake.modules.nixos.pc =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.desktop.niri;

      includedConfigs = sharedConfigs ++ lib.optional (cfg.extraConfig != "") "host";

      configKdl = pkgs.writeText "config.kdl" (
        lib.concatMapStrings (name: "include \"config/${name}.kdl\"\n") includedConfigs
      );

      hostKdl = pkgs.writeText "host.kdl" cfg.extraConfig;

      # 壊れた KDL を deploy しないよう、ビルド時に niri validate を通す
      configDir =
        pkgs.runCommand "niri-config" { nativeBuildInputs = [ config.programs.niri.package ]; }
          ''
            mkdir -p $out/config
            cp ${configKdl} $out/config.kdl
            ${lib.concatMapStrings (name: "cp ${./. + "/${name}.kdl"} $out/config/${name}.kdl\n") sharedConfigs}
            ${lib.optionalString (cfg.extraConfig != "") "cp ${hostKdl} $out/config/host.kdl"}
            HOME=$TMPDIR niri validate -c $out/config.kdl
          '';

      home = {
        home.file = builtins.listToAttrs (
          map (path: {
            name = ".config/niri/${path}";
            value = {
              source = "${configDir}/${path}";
              force = true;
            };
          }) ([ "config.kdl" ] ++ map (name: "config/${name}.kdl") includedConfigs)
        );
      };
    in
    {
      options.desktop.niri = {
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = "Host-specific niri config (outputs, DRM devices, ...), included after the shared config.";
        };

        configDir = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          internal = true;
          description = "Validated niri config directory. Built by `nix flake check` as well.";
        };
      };

      config = {
        desktop.niri.configDir = configDir;

        people.home.imports = [ home ];

        nixpkgs.overlays = [ xwaylandSatellitePinOverlay ];

        programs.niri.enable = true;
        programs.xwayland.enable = true;
        programs.dconf.enable = true;

        environment.systemPackages = with pkgs; [
          imv
          mpv
          grim
          slurp
          xwayland-satellite
          libnotify
        ];

        # programs.niri が gnome portal と niri 向けの portal 設定 (ScreenCast や
        # Secret など) を入れるので、ここでは gtk portal と niri 以外の既定だけ足す
        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          config.common.default = [ "gtk" ];
        };

        # XDG_SESSION_TYPE や XDG_CURRENT_DESKTOP は niri --session が自分で設定し、
        # greetd のセッションにだけ渡している (modules/desktop/greetd.nix)。
        # ここに書くと /etc/pam/environment 経由で ssh や tty のセッションにまで付く。
        # SDL_VIDEODRIVER も強制しない: Steam のネイティブゲーム (Unity など) が
        # Wayland バックエンドで落ちるので、SDL 自身の選択 (X11 なら xwayland-satellite) に任せる。
        environment.sessionVariables = {
          CLUTTER_BACKEND = "wayland";

          # Chromium / Electron
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };
      };
    };
}
