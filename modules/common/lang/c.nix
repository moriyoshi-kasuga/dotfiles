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
      (lib.hiPrio llvmPackages.clang-unwrapped)
    ];
  };
  darwinHomeModule = {
    home.packages = with pkgs; [
      libcxx
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
