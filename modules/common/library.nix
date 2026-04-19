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
        curl
        openssl
        libssh
        sqlite
        icu
        lua5_4
        pkg-config
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
  darwinHomeModule = {
    modules.library.libs = with pkgs; [
      libiconv
      llvm
      nsis
    ];
  };
  nixosModule = {
    environment.systemPackages = with pkgs; [
      pkg-config
    ];
  };
  linuxHomeModule = {
    modules.library.libs = with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      attr
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz

      # My own additions
      libxcomposite
      libxtst
      libxrandr
      libxext
      libx11
      libxfixes
      libxkbcommon
      libxi
      libGL
      libva
      pipewire
      libxcb
      libxdamage
      libxshmfence
      libxxf86vm
      libelf
      udev
      librsvg
      webkitgtk_4_1
    ];
  };
}
