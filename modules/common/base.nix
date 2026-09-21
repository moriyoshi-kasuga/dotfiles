{ inputs, vars, ... }:

let
  version = "26.05";
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "sapphire";
  };
  nixSettings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = false;
  };
  nixRegistry = {
    nixpkgs.flake = inputs.nixpkgs;
  };

  # nixos/darwin 共通の nix.* 設定。ホスト固有の差分は settings/gc に対する `//` で追加する。
  mkNixCommon =
    {
      extraSettings ? { },
      extraGc ? { },
    }:
    {
      settings = nixSettings // extraSettings;
      optimise.automatic = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      }
      // extraGc;
      registry = nixRegistry;
    };

  nixpkgsCommon = {
    overlays = [ inputs.nix-claude-code.overlays.default ];
    config.allowUnfree = true;
  };

  homeManagerCommon = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit vars inputs; };
  };
in
{
  flake.modules.homeManager.base =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      inherit catppuccin;
      programs.home-manager.enable = true;

      home.stateVersion = version;
      home.sessionVariables = {
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      };

      home.packages = [
        pkgs.fastfetch
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
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
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
        inputs.home-manager.nixosModules.home-manager
      ];

      options.people.primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "Primary user of this NixOS host.";
      };

      config = {
        inherit catppuccin;
        nixpkgs = nixpkgsCommon;

        home-manager = homeManagerCommon // {
          backupFileExtension = "nixbackup";
          sharedModules = [
            inputs.noctalia.homeModules.default
          ];
        };

        system.stateVersion = version;

        users.users.${config.people.primaryUser}.packages = [
          pkgs.wl-clipboard
        ];

        nix =
          mkNixCommon {
            extraSettings.trusted-users = [ config.people.primaryUser ];
            extraGc.dates = "weekly";
          }
          // {
            package = pkgs.nixVersions.latest;
            channel.enable = false;
          };

        programs.command-not-found.enable = false;

        documentation.enable = false;
      };
    };

  flake.modules.darwin.base =
    { ... }:
    {
      imports = [ inputs.home-manager.darwinModules.home-manager ];

      nixpkgs = nixpkgsCommon;

      home-manager = homeManagerCommon;

      nix = mkNixCommon { };
      system.stateVersion = 6;
    };
}
