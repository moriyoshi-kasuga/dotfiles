{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.zig";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      zig
    ];
  };
}
