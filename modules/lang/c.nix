{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    cmake
    gcc
    pkg-config
  ];
}
