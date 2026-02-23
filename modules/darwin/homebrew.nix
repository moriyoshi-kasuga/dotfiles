{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.homebrew";
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
