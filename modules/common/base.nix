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
  linuxHomeModule = {
    home.packages = with pkgs; [
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
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixpkgs.hostPlatform = system;
    system.stateVersion = 6;
    system.primaryUser = username;

    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];

    users.users.${username}.home = homeDirectory;
  };
}
