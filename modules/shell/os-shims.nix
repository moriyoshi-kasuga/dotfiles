_:

let
  # macOS と Linux で同じ名前のコマンドを使えるようにする shim
  darwinNotify =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "notify" ''
          osascript -e "display notification \"$1\" with title \"''\${2:-Notification}\""
        '')
      ];
    };

  linuxNotify =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "notify" ''
          : "''${DBUS_SESSION_BUS_ADDRESS:=unix:path=/run/user/$(${pkgs.coreutils}/bin/id -u)/bus}"
          export DBUS_SESSION_BUS_ADDRESS
          if [ $# -eq 1 ]; then
            ${pkgs.libnotify}/bin/notify-send --urgency normal --expire-time=5000 \
              --category=x-generic --icon=dialog-information "$1"
          else
            ${pkgs.libnotify}/bin/notify-send --urgency normal --expire-time=5000 \
              --category=x-generic --icon=dialog-information --app-name "$2" "$1"
          fi
        '')
      ];
    };

  # クリップボードと open は画面のある host でだけ意味がある
  linuxDesktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
        xdg-utils
        (writeShellScriptBin "pbpaste" ''
          ${wl-clipboard}/bin/wl-paste --no-newline
        '')
        (writeShellScriptBin "pbcopy" ''
          ${wl-clipboard}/bin/wl-copy
        '')
        (writeShellScriptBin "open" ''
          ${xdg-utils}/bin/xdg-open "$@"
        '')
      ];
    };
in
{
  flake.modules.darwin.base.people.home.imports = [ darwinNotify ];
  flake.modules.nixos.base.people.home.imports = [ linuxNotify ];
  flake.modules.nixos.pc.people.home.imports = [ linuxDesktop ];
}
