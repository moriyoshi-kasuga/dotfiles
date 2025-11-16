{ pkgs, vars, ... }:

{
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.hostPlatform = vars.system;
  system.stateVersion = 6;
  system.primaryUser = "${vars.username}";

  imports = [
    ./dock.nix
    ./finder.nix
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # !! 注意 !!
      # cleanup = "uninstall";
    };
    casks = [
      "wezterm"
      "brave-browser"
      "raycast"
      "visual-studio-code"
      "discord"
    ];
  };
}
