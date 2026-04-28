{
  pkgs,
  mkModule,
  ...
}:

let
  wallpaperSrc = pkgs.fetchFromGitHub {
    owner = "orangci";
    repo = "walls";
    rev = "f61033f92cc24c60aebd306e113eb2aacd498c0f";
    hash = "sha256-2/dZGA5IoYANTUlR0I/GUtO8GeOlzAHouyjtKuVvcl4=";
  };

  mkRotateScript =
    setWallpaperCmd:
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
  darwinHomeModule =
    let
      darwinRotate = mkRotateScript ''
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
    let
      nixosRotate = mkRotateScript ''
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
