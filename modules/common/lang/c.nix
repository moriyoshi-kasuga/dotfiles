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
      llvmPackages.clang-unwrapped
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
