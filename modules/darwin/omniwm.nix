{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.omniwm";
  inheritModule = "darwin";
  homeModule = {
    xdg.configFile."omniwm/settings.toml" = {
      source = ./omniwm.toml;
      force = true;
    };
  };
  darwinModule = {
    homebrew = {
      taps = [
        "BarutSRB/tap"
      ];
      casks = [
        "omniwm"
      ];
    };
  };
}
