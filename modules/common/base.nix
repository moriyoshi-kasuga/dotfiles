{
  lib,
  pkgs,
  mkModule,
  username,
  homeDirectory,
  system,
  ...
}:

let
  version = "26.05";
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "sapphire";
  };
in
mkModule {
  name = "base";
  homeModule = {
    inherit catppuccin;
    programs.home-manager.enable = true;

    home = {
      inherit username homeDirectory;
      stateVersion = version;
      sessionVariables = {
        XDG_CONFIG_HOME = "${homeDirectory}/.config";
      };
    };

    home.packages = [
      pkgs.fastfetch
    ];
  };
  darwinHomeModule = {
    home.packages = with pkgs; [
      (writeShellScriptBin "notify" ''
        osascript -e "display notification \"$1\" with title \"''\${2:-Notification}\""
      '')
    ];
  };
  linuxHomeModule = {
    home.packages = with pkgs; [
      (writeShellScriptBin "notify" ''
        : "''${DBUS_SESSION_BUS_ADDRESS:=unix:path=/run/user/$(${pkgs.coreutils}/bin/id -u)/bus}"
        export DBUS_SESSION_BUS_ADDRESS
        if [ $# -eq 1 ]; then
          ${pkgs.libnotify}/bin/notify-send --urgency low --transient --expire-time=5000 \
            --category=x-generic --icon=dialog-information "$1"
        else
          ${pkgs.libnotify}/bin/notify-send --urgency low --transient --expire-time=5000 \
            --category=x-generic --icon=dialog-information --app-name "$2" "$1"
        fi
      '')

      (writeShellScriptBin "pbpaste" ''
        wl-paste --no-newline
      '')
      (writeShellScriptBin "pbcopy" ''
        wl-copy --trim-newline
      '')
      (writeShellScriptBin "open" ''
        xdg-open "$@"
      '')
    ];
  };
  nixosModule = {
    inherit catppuccin;
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
      ];

    home-manager.backupFileExtension = "nixbackup";
    system.stateVersion = version;

    users.users.${username}.packages = [
      pkgs.wl-clipboard
    ];

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
      };
      optimise.automatic = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
  };
  darwinModule = {
    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      settings.trusted-users = [
        "root"
        username
      ];
    };
    nixpkgs.hostPlatform = system;
    system.stateVersion = 6;
    system.primaryUser = username;

    users.users.${username}.home = homeDirectory;
  };
}
