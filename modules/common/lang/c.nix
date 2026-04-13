{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.c";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      gnumake
      lld
      cmake
      ninja
      clang-tools
      clang
    ];
  };
  darwinHomeModule = {
    home.packages = with pkgs; [
      cctools
    ];
  };
}
