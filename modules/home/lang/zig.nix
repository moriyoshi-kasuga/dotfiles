{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "zig";
  module = {
    home.packages = with pkgs; [
      zig
    ];
  };
}
