{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.zig";
  module = {
    home.packages = with pkgs; [
      zig
    ];
  };
}
