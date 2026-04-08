{
  mkModule,
  ...
}:

mkModule {
  name = "lang.node";
  inheritModule = "lang";
  homeModule = {
    programs.mise.globalConfig.tools = {
      node = "25.9.0";
      bun = "1.3.11";
    };
  };
}
