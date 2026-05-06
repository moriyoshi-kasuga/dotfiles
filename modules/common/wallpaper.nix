{
  pkgs,
  lib,
  mkModule,
  ...
}:

let
  wallpaperMap = {
    "orangci/walls-catppuccin-mocha" = {
      rev = "7bfdf10d16ad3a689f9f0cf3a0930da3d1a245a8";
      hash = "sha256-N+MZHSRcwOldS5Ai8B3YfKquKs9oeUW/GkV1iKM5+i8=";
    };
    "dharmx/walls" = {
      rev = "6bf4d733ebf2b484a37c17d742eb47e5139e6a14";
      hash = "sha256-M96jJy3L0a+VkJ+DcbtrRAquwDWaIG9hAUxenr/TcQU=";
    };
  };

  mkRotateScript =
    owner: repo: setWallpaperCmd:
    let
      key = "${owner}/${repo}";
      wallpaperDef = wallpaperMap.${key} or (throw "wallpaper not found: ${key}");
      wallpaperSrc = pkgs.fetchFromGitHub {
        inherit owner repo;
        rev = wallpaperDef.rev;
        hash = wallpaperDef.hash;
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
  options = {
    owner = lib.mkOption {
      type = lib.types.str;
      description = "repository owner";
    };
    repo = lib.mkOption {
      type = lib.types.str;
      description = "repository name";
    };
  };
  darwinHomeModule =
    { cfg, ... }:
    let
      rotateScript = mkRotateScript cfg.owner cfg.repo ''
        /usr/bin/osascript -e "tell application \"System Events\" to set picture of every desktop to \"$FILE\""
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
    { cfg, ... }:
    let
      rotateScript = mkRotateScript cfg.owner cfg.repo ''
        noctalia-shell ipc call wallpaper set "$FILE"
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
