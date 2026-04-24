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

    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
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
