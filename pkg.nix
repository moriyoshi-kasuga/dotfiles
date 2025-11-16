{
  pkgs,
  lib,
  config,
  ...
}:

let
  packages =
    config.pkgPackages
    ++ (
      with pkgs;
      [
        ffmpeg
        openssl
        sqlite
      ]
      ++ lib.optionals (pkgs.stdenv.isLinux) [
        wayland
        alsa-lib
        vulkan-loader
        vulkan-tools
        libudev-zero
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
        libxkbcommon
      ]
    );
in
{
  options.pkgPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Additional packages to include for PKG_CONFIG_PATH";
  };

  config = {
    home.packages = packages;
    home.sessionVariables = {
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
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
        with pkgs;
        [
          openssl
          sqlite
          ffmpeg
        ]
        ++ pkgs.lib.optionals (pkgs.stdenv.isLinux) [
          wayland
          vulkan-loader
          libudev-zero
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          libxkbcommon
        ]
      );
    };
  };
}
