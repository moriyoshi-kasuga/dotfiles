{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "darwin.homebrew";
  inheritModule = "darwin";
  darwinModule = {
    homebrew = {
      enable = true;
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
