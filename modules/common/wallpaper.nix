{
  pkgs,
  inputs,
  mkModule,
  ...
}:

let
  # Pinned via the `wallpapers` flake input; updated by `./init.sh update`.
  wallpaperSrc = inputs.wallpapers.outPath;

  mkRotateScript =
    setWallpaperCmd:
    pkgs.writeShellApplication {
      name = "wallpaper-rotate";
      runtimeInputs = [
        pkgs.fd
        pkgs.yazi
      ];
      text = ''
        CACHE_DIR="$HOME/.cache/wallpaper-rotate"
        CACHE_FILE="$CACHE_DIR/shown.txt"
        STOP_FLAG="$CACHE_DIR/stopped"

        mkdir -p "$CACHE_DIR"

        case "''${1:-}" in
          --stop)
            touch "$STOP_FLAG"
            echo "wallpaper rotation stopped"
            exit 0
            ;;
          --start)
            rm -f "$STOP_FLAG"
            echo "wallpaper rotation started"
            exit 0
            ;;
          --choice)
            CHOOSER_FILE=$(mktemp)
            yazi ${wallpaperSrc} --chooser-file "$CHOOSER_FILE"
            FILE=$(cat "$CHOOSER_FILE")
            rm -f "$CHOOSER_FILE"
            if [ -z "$FILE" ]; then
              echo "No file selected" >&2
              exit 1
            fi
            ${setWallpaperCmd}
            exit 0
            ;;
        esac

        if [ -f "$STOP_FLAG" ]; then
          exit 0
        fi

        touch "$CACHE_FILE"

        mapfile -t ALL_WALLPAPERS < <(fd . -t f -e png -e jpg ${wallpaperSrc})

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
  darwinHomeModule =
    let
      rotateScript = mkRotateScript ''
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
    };
  linuxHomeModule =
    let
      rotateScript = mkRotateScript ''
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
    };
}
