{
  mkModule,
  pkgs,
  username,
  ...
}:

mkModule {
  name = "darwin.homebrew";
  inheritModule = "darwin";
  homeModule = {
    programs.fish = {
      interactiveShellInit = ''
        /opt/homebrew/bin/brew shellenv | source
      '';
    };
  };
  darwinModule = {
    homebrew = {
      enable = true;
      user = username;
      onActivation = {
        autoUpdate = true;
      };
      casks = [
        "brave-browser"
        "raycast"
        "visual-studio-code"
        "discord"
        "slack"
        "figma"
        "zed"
        "macfuse"
      ];
    };

    environment.systemPackages = with pkgs; [
      xcodegen
      libimobiledevice
      swift
      cocoapods
      xcodes
    ];
  };
}
