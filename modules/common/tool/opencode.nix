{
  mkModule,
  ...
}:

mkModule {
  name = "tool.opencode";
  homeModule = {
    xdg.configFile."opencode/opencode.json".source = ./opencode.json;
  };
}
