{ inputs, ... }:

let
  mkRotateScript =
    pkgs: setWallpaperCmd:
    let
      # Pinned via the `wallpapers` flake input; updated by `./init.sh update`.
      wallpaperSrc = inputs.wallpapers.outPath;
    in
    pkgs.writeShellApplication {
      name = "wallpaper-rotate";
      runtimeInputs = [
        pkgs.fd
        pkgs.yazi
      ];
      runtimeEnv = {
        WALLPAPER_SRC = wallpaperSrc;
        SET_WALLPAPER_CMD = setWallpaperCmd;
      };
      text = builtins.readFile ./wallpaper-rotate.sh;
    };
in
{
  flake.modules.homeManager.wallpaper =
    { pkgs, lib, ... }:
    lib.mkMerge [
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
        let
          rotateScript = mkRotateScript pkgs ''
            /usr/bin/osascript \
              -e "tell application \"System Events\"" \
              -e "repeat with d in desktops" \
              -e "tell d" \
              -e "set picture to \"$FILE\"" \
              -e "set |picture scaling| to 0" \
              -e "end tell" \
              -e "end repeat" \
              -e "end tell"
          '';
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
        }
      ))
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        let
          rotateScript = mkRotateScript pkgs ''
            noctalia msg wallpaper-set "$FILE"
          '';
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
        }
      ))
    ];
}
