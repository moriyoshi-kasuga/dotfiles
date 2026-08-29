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
    auto-optimise-store = true;
  };
  nixRegistry = {
    nixpkgs.flake = inputs.nixpkgs;
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
        nixpkgs.overlays = [ inputs.nix-claude-code.overlays.default ];
        nixpkgs.config.allowUnfree = true;

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "nixbackup";
        home-manager.extraSpecialArgs = { inherit vars; };
        home-manager.sharedModules = [
          inputs.noctalia.homeModules.default
        ];

        system.stateVersion = version;

        users.users.${config.people.primaryUser}.packages = [
          pkgs.wl-clipboard
        ];

        nix = {
          settings = nixSettings;
          optimise.automatic = true;
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
          registry = nixRegistry;
        };

        documentation.enable = false;
      };
    };

  flake.modules.darwin.base =
    { ... }:
    {
      imports = [ inputs.home-manager.darwinModules.home-manager ];

      nixpkgs.overlays = [ inputs.nix-claude-code.overlays.default ];
      nixpkgs.config.allowUnfree = true;

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit vars; };

      nix = {
        settings = nixSettings;
        optimise.automatic = true;
        gc = {
          automatic = true;
          options = "--delete-older-than 7d";
        };
        registry = nixRegistry;
      };
      system.stateVersion = 6;
    };
}
