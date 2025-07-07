{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    cmake
    llvmPackages.bintools
    pkg-config
    ninja
    openssl
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

}
