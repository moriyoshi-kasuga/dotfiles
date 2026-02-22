{
  mkModule,
  ...
}:

mkModule {
  name = "homebrew";
  module = {
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
