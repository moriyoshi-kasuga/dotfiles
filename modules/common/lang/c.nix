{
  pkgs,
  lib,
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
      (lib.hiPrio gcc)
      (lib.lowPrio binutils)
    ];
  };
  darwinHomeModule = {
    home.packages = with pkgs; [
      libcxx
      cctools
    ];
  };
}
