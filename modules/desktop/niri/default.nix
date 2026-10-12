_:

let
  # config.kdl はこの順に config/*.kdl を include し、その後に Nix の値から作る
  # config (generatedConfigs) を include する。後の include ほど優先されるので、
  # ホスト固有の設定 (host.kdl) は最後に置く。
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
      inherit (config.catppuccin) cursors;

      generatedConfigs = [
        {
          # 他の cursor 設定は misc.kdl にあり、include 間でプロパティごとにマージされる
          name = "cursor";
          text = ''
            cursor {
              xcursor-theme "catppuccin-${cursors.flavor}-${cursors.accent}-cursors"
            }
          '';
        }
      ]
      ++ lib.optional (cfg.extraConfig != "") {
        name = "host";
        text = cfg.extraConfig;
      };

      includedConfigs = sharedConfigs ++ map (c: c.name) generatedConfigs;

      configKdl = pkgs.writeText "config.kdl" (
        lib.concatMapStrings (name: "include \"config/${name}.kdl\"\n") includedConfigs
      );

      # 壊れた KDL を deploy しないよう、ビルド時に niri validate を通す
      configDir =
        pkgs.runCommand "niri-config" { nativeBuildInputs = [ config.programs.niri.package ]; }
          ''
            mkdir -p $out/config
            cp ${configKdl} $out/config.kdl
            ${lib.concatMapStrings (name: "cp ${./. + "/${name}.kdl"} $out/config/${name}.kdl\n") sharedConfigs}
            ${lib.concatMapStrings (
              c: "cp ${pkgs.writeText "${c.name}.kdl" c.text} $out/config/${c.name}.kdl\n"
            ) generatedConfigs}
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
          brightnessctl
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
