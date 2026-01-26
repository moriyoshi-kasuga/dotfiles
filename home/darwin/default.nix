{ pkgs, ... }:
{
  home.packages = with pkgs; [
    llvmPackages.bintools
    nsis
  ];
}
