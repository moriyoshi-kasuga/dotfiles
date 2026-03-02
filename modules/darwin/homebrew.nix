{
  mkModule,
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
      ];
    };
  };
}
