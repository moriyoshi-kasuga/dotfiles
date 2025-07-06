{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    cmake
    llvmPackages.bintools
    pkg-config
    ninja
  ];
}
