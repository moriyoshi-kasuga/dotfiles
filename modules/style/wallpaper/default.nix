{ inputs, ... }:

let
  # setWallpaper は画像のパスを 1 つ受け取って壁紙にする実行ファイルで、OS ごとに用意する
  mkRotateScript =
    pkgs: setWallpaper:
    pkgs.writeShellApplication {
      name = "wallpaper-rotate";
      runtimeInputs = [
        pkgs.fd
        pkgs.yazi
      ];
      runtimeEnv = {
        # Pinned via the `wallpapers` flake input; updated by `./init.sh update`.
        WALLPAPER_SRC = inputs.wallpapers.outPath;
        SET_WALLPAPER = setWallpaper;
      };
      text = builtins.readFile ./wallpaper-rotate.sh;
    };

  darwinHome =
    { pkgs, ... }:
    let
      rotateScript = mkRotateScript pkgs (
        pkgs.writeShellScript "set-wallpaper" ''
          /usr/bin/osascript \
            -e "tell application \"System Events\"" \
            -e "repeat with d in desktops" \
            -e "tell d" \
            -e "set picture to \"$1\"" \
            -e "set |picture scaling| to 0" \
            -e "end tell" \
            -e "end repeat" \
            -e "end tell"
        ''
      );
    in
    {
      home.packages = [ rotateScript ];

      launchd.agents.wallpaper-rotate = {
        enable = true;
        config = {
          ProgramArguments = [ "${rotateScript}/bin/wallpaper-rotate" ];
          StartInterval = 5 * 60;
          RunAtLoad = true;
        };
      };
    };

  # 壁紙の表示は noctalia (desktop/noctalia.nix、同じ nixos.pc) に任せる
  linuxHome =
    { pkgs, ... }:
    let
      rotateScript = mkRotateScript pkgs (
        pkgs.writeShellScript "set-wallpaper" ''
          noctalia msg wallpaper-set "$1"
        ''
      );
    in
    {
      home.packages = [ rotateScript ];

      systemd.user.timers."wallpaper" = {
        Unit.Description = "Wallpaper rotation timer";
        Timer = {
          OnBootSec = "5m";
          OnUnitActiveSec = "5m";
        };
        Install.WantedBy = [ "timers.target" ];
      };

      systemd.user.services."wallpaper" = {
        Unit.Description = "Rotate wallpaper";
        Service = {
          Type = "oneshot";
          ExecStart = "${rotateScript}/bin/wallpaper-rotate";
        };
      };
    };
in
{
  flake.modules.darwin.pc.people.home.imports = [ darwinHome ];
  flake.modules.nixos.pc.people.home.imports = [ linuxHome ];
}
