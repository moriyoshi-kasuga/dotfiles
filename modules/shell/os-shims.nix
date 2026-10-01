_:

{
  # macOS と Linux で同じ名前のコマンドを使えるようにする shim
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    {
      home.packages =
        lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          (pkgs.writeShellScriptBin "notify" ''
            osascript -e "display notification \"$1\" with title \"''\${2:-Notification}\""
          '')
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
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

          (pkgs.writeShellScriptBin "pbpaste" ''
            wl-paste --no-newline
          '')
          (pkgs.writeShellScriptBin "pbcopy" ''
            wl-copy
          '')
          (pkgs.writeShellScriptBin "open" ''
            xdg-open "$@"
          '')
        ];
    };

  flake.modules.nixos.base =
    { pkgs, config, ... }:
    {
      users.users.${config.people.primaryUser}.packages = [
        pkgs.wl-clipboard
      ];
    };
}
