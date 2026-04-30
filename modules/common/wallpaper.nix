{
  pkgs,
  lib,
  mkModule,
  ...
}:

let
  mkRotateScript =
    isCatppuccin: setWallpaperCmd:
    let
      wallpaperSrc =
        if isCatppuccin then
          pkgs.fetchFromGitHub {
            owner = "orangci";
            repo = "walls-catppuccin-mocha";
            rev = "7bfdf10d16ad3a689f9f0cf3a0930da3d1a245a8";
            hash = "sha256-N+MZHSRcwOldS5Ai8B3YfKquKs9oeUW/GkV1iKM5+i8=";
          }
        else
          pkgs.fetchFromGitHub {
            owner = "orangci";
            repo = "walls";
            rev = "f61033f92cc24c60aebd306e113eb2aacd498c0f";
            hash = "sha256-2/dZGA5IoYANTUlR0I/GUtO8GeOlzAHouyjtKuVvcl4=";
          };
    in
    pkgs.writeShellApplication {
      name = "wallpaper-rotate";
      runtimeInputs = [ pkgs.fd ];
      text = ''
        CACHE_DIR="$HOME/.cache/wallpaper-rotate"
        CACHE_FILE="$CACHE_DIR/shown.txt"

        mkdir -p "$CACHE_DIR"
        touch "$CACHE_FILE"

        mapfile -t ALL_WALLPAPERS < <(fd . -t f -e jpg ${wallpaperSrc})

        if [ "''${#ALL_WALLPAPERS[@]}" -eq 0 ]; then
          echo "No wallpapers found" >&2
          exit 1
        fi

        mapfile -t REMAINING < <(
          printf '%s\n' "''${ALL_WALLPAPERS[@]}" | while IFS= read -r wp; do
            grep -qxF "$wp" "$CACHE_FILE" || echo "$wp"
          done
        )

        if [ "''${#REMAINING[@]}" -eq 0 ]; then
          : > "$CACHE_FILE"
          REMAINING=("''${ALL_WALLPAPERS[@]}")
        fi

        INDEX=$(( RANDOM % ''${#REMAINING[@]} ))
        FILE="''${REMAINING[$INDEX]}"

        echo "$FILE" >> "$CACHE_FILE"

        ${setWallpaperCmd}
      '';
    };
in
mkModule {
  name = "wallpaper";
  options = {
    isCatppuccin = lib.mkEnableOption "color";
  };
  darwinHomeModule =
    { cfg, ... }:
    let
      darwinRotate = mkRotateScript cfg.isCatppuccin ''
        /usr/bin/osascript -e "tell application \"System Events\" to set picture of every desktop to \"$FILE\""
      '';
    in
    {
      home.packages = [ darwinRotate ];

      launchd.agents.wallpaper-rotate = {
        enable = true;
        config = {
          ProgramArguments = [ "${darwinRotate}/bin/wallpaper-rotate" ];
          StartInterval = 5 * 60;
          RunAtLoad = true;
        };
      };
    };
  linuxHomeModule =
    { cfg, ... }:
    let
      nixosRotate = mkRotateScript cfg.isCatppuccin ''
        noctalia-shell ipc call wallpaper set "$FILE"
      '';
    in
    {
      home.packages = [ nixosRotate ];

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
          ExecStart = "${nixosRotate}/bin/wallpaper-rotate";
        };
      };
    };
}
