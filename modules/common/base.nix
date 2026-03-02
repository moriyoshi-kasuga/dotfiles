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
in
mkModule {
  name = "base";
  homeModule = {
    programs.home-manager.enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "sapphire";
    };

    home = {
      inherit username homeDirectory;
      stateVersion = version;
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
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
      ];

    home-manager.backupFileExtension = "nixbackup";
    system.stateVersion = version;

    users.users.${username} = {
      isNormalUser = true;
      description = username;
      group = username;
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "audio"
        "video"
      ];
      packages = with pkgs; [
        wl-clipboard
      ];
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
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
