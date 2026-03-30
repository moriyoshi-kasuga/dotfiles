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
      ];
    };

    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };
  };
}
