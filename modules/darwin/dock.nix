{
  mkModule,
  pkgs,
  username,
  ...
}:

mkModule {
  name = "darwin.dock";
  inheritModule = "darwin";
  darwinHomeModule =
    { ... }:
    let
      wallpapers = pkgs.fetchFromGitHub {
        owner = "orangci";
        repo = "walls";
        rev = "f61033f92cc24c60aebd306e113eb2aacd498c0f";
        hash = "sha256-2/dZGA5IoYANTUlR0I/GUtO8GeOlzAHouyjtKuVvcl4=";
      };
    in
    {
      home.packages = [
        pkgs.coreutils # shuf用
      ];

      home.file.".local/bin/wallpaper-rotate".text = ''
        #!/usr/bin/env bash
        FILE=$(find "${wallpapers}" -type f -iname "*.jpg" -o -iname "*.png" | shuf -n 1)

        /usr/bin/osascript <<EOF
        tell application "System Events"
          set picture of every desktop to "$FILE"
        end tell
        EOF
      '';

      home.file.".local/bin/wallpaper-rotate".executable = true;

      launchd.agents.wallpaper-rotate = {
        enable = true;

        config = {
          ProgramArguments = [ "/Users/${username}/.local/bin/wallpaper-rotate" ];
          StartInterval = 5 * 60;
          RunAtLoad = true;
        };
      };
    };
  darwinModule = {
    system.defaults.dock = {
      autohide = true;
      show-recents = false;
      tilesize = 50;
      magnification = true;
      largesize = 64;
      orientation = "bottom";
      mineffect = "scale";
      launchanim = false;
    };
    system.defaults.spaces.spans-displays = true;
    system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  };
}
