{
  lib,
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "library";
  options = {
    libs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages";
    };
  };
  homeModule =
    { cfg, ... }:
    {
      modules.library.libs = with pkgs; [
        ffmpeg
        openssl
        sqlite
        icu
        lua5_4
      ];
      home.packages = cfg.libs;
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
            pkgConfigPaths = builtins.filter (x: x != null) (map getPkgConfigPath cfg.libs);
          in
          lib.concatStringsSep ":" pkgConfigPaths;
        LD_LIBRARY_PATH = lib.makeLibraryPath cfg.libs;
        LIBRARY_PATH = LD_LIBRARY_PATH;
      };
    };
  linuxHomeModule = {

  };
  darwinHomeModule = {
    modules.library.libs = with pkgs; [
      libiconv
    ];
  };
}
