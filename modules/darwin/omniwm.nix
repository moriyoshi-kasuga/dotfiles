{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.omniwm";
  inheritModule = "darwin";
  homeModule = {
    home.file.".config/omniwm/settings.toml" = {
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
