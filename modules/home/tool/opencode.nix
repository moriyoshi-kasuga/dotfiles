{
  mkModule,
  ...
}:

mkModule {
  name = "tool.opencode";
  module = {
    xdg.configFile."opencode/opencode.json".source = ./opencode.json;
  };
}
