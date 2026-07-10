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
      clang
    ];
  };
  darwinHomeModule = {
    home.packages = with pkgs; [
      libcxx
      cctools
    ];
  };
  linuxHomeModule = {
    home.packages = with pkgs; [
      mold
    ];
    home.sessionVariables = {
      CFLAGS = "-fuse-ld=mold";
      CXXFLAGS = "-fuse-ld=mold";
      LDFLAGS = "-fuse-ld=mold";
    };
  };
}
