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
      binutils
      gcc
    ];
  };
  darwinHomeModule = {
    home.packages = with pkgs; [
      cctools
    ];
  };
}
