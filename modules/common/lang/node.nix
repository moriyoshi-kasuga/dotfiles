{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "lang.node";
  inheritModule = "lang";
  homeModule = {
    programs.mise.globalConfig.tools = {
      deno = "2.8.0";
    };
  };
  darwinHomeModule = {
    programs.mise.globalConfig.tools = {
      node = "24.15.0";
    };
  };
  linuxHomeModule = {
    home.packages = with pkgs; [
      nodejs_24
    ];
  };
}
