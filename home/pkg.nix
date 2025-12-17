{
  pkgs,
  lib,
  config,
  ...
}:

let
  packages =
    (with pkgs; [
      ffmpeg
      openssl
      sqlite
      icu
    ])
    ++ config.pkgPackages;
  ldLibraryPathPackages =
    (with pkgs; [
      openssl
      sqlite
      ffmpeg
      icu
    ])
    ++ config.ldLibraryPathPackages;
in
{
  options.pkgPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Additional packages to include for PKG_CONFIG_PATH";
  };
  options.ldLibraryPathPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Additional packages to include for LD_LIBRARY_PATH";
  };

  config = {
    home.packages = packages;
    home.sessionVariables = rec {
      PKG_CONFIG_PATH =
        let
          getPkgConfigPath =
            pkg:
            let
              pcpath = pkg.dev or pkg;
              path = "${pcpath}/lib/pkgconfig";
            in
            if builtins.pathExists path then path else null;
          pkgConfigPaths = builtins.filter (x: x != null) (map getPkgConfigPath packages);
        in
        pkgs.lib.concatStringsSep ":" pkgConfigPaths;
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath ldLibraryPathPackages;
      LIBRARY_PATH = LD_LIBRARY_PATH;
    };
  };
}
