_:

let
  linuxLibs =
    pkgs: with pkgs; [
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
      vulkan-loader
      vulkan-tools
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
      libxrender
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
      cairo
      at-spi2-atk
      atkmm
      libsoup_3
      harfbuzz
      pango
      pangomm
      glib
      webkitgtk_4_1
      wayland
    ];
in
{
  flake.modules.homeManager.library =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.modules.library;
    in
    {
      options.modules.library.libs = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Additional packages";
      };

      config = lib.mkMerge [
        {
          modules.library.libs = with pkgs; [
            imagemagick
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
        }
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          modules.library.libs = with pkgs; [
            libiconv
            llvm
            nsis
          ];
          home.sessionVariablesExtra = ''
            export SDKROOT="$(xcrun --show-sdk-path)"
            export CC_aarch64_apple_darwin=/usr/bin/cc
            export CXX_aarch64_apple_darwin=/usr/bin/c++
          '';
        })
        (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          modules.library.libs = linuxLibs pkgs;
        })
      ];
    };

  flake.modules.nixos.library =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        pkg-config
      ];
      programs.nix-ld.libraries = linuxLibs pkgs;
    };
}
