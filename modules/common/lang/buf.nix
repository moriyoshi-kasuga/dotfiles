{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.buf";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      buf
      protobuf
    ];
  };
}
