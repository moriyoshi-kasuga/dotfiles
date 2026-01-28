{
  pkgs,
  system,
  username,
  homeDirectory,
  ...
}:

{
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.hostPlatform = system;
  system.stateVersion = 6;
  system.primaryUser = username;

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.shells = [ pkgs.fish ];

  users.users.${username} = {
    home = homeDirectory;
    shell = pkgs.fish;
  };

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
      "slack"
      "figma"
    ];
  };
}
