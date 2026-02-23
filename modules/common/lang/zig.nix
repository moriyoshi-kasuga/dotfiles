{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.zig";
  homeModule = {
    home.packages = with pkgs; [
      zig
    ];
  };
}
