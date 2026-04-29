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
      libxinerama
      libx11
      libxcursor
      libxfixes
      libxkbcommon
      libxi
      libGL
      mesa
      alsa-lib
      libva
      pipewire
      libxcb
      libxdamage
      libxshmfence
      libxxf86vm
      libelf
      libinput
      udev

      libev
      libevdev
      gdk-pixbuf
      gobject-introspection
      gtk3
      gio-sharp
      cairo
      at-spi2-atk
      atkmm
      libsoup_3
      harfbuzz
      pango
      pangomm
      glib
      webkitgtk_4_1
    ];
  };
}
