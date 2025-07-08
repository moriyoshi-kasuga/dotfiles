{ pkgs, ... }:

let
  pkgConfigModules = with pkgs; [
    ffmpeg
    openssl
    sqlite
  ];
in
{
  home.packages =
    with pkgs;
    [
      gnumake
      cmake
      llvmPackages.bintools
      pkg-config
      ninja
    ]
    ++ pkgConfigModules;

  home.sessionVariables.PKG_CONFIG_PATH =
    let
      getPkgConfigPath =
        pkg:
        let
          pcpath = pkg.dev or pkg;
          path = "${pcpath}/lib/pkgconfig";
        in
        if builtins.pathExists path then path else null;
      pkgConfigPaths = builtins.filter (x: x != null) (map getPkgConfigPath pkgConfigModules);
    in
    pkgs.lib.concatStringsSep ":" pkgConfigPaths;
}
