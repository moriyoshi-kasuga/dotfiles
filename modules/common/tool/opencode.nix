{
  mkModule,
  ...
}:

mkModule {
  name = "tool.opencode";
  inheritModule = "tool";
  homeModule = {
    ."opencode/opencode.json".source = ./opencode.json;
  };
}
