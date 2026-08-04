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
    ];
  };
  darwinHomeModule = {
    home.packages = with pkgs; [
      libcxx
      (lib.hiPrio llvmPackages.clang-unwrapped)
    ];
  };
  linuxHomeModule = {
    home.packages = with pkgs; [
      mold
      (lib.hiPrio clang)
    ];
    home.sessionVariables = {
      CFLAGS = "-fuse-ld=mold";
      CXXFLAGS = "-fuse-ld=mold";
      LDFLAGS = "-fuse-ld=mold";
    };
  };
}
