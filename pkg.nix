{
  pkgs,
  lib,
  config,
  ...
}:

let
  packages = config.pkgPackages ++ [
    pkgs.ffmpeg
    pkgs.openssl
    pkgs.sqlite
  ];
in
{
  options.pkgPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Additional packages to include for PKG_CONFIG_PATH";
  };

  config = {
    home.packages = packages;

    home.sessionVariables.PKG_CONFIG_PATH =
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
  };
}
