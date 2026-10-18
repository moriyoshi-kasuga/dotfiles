_:

let
  # 画面のない host でも、配布バイナリの実行やネイティブ拡張のビルドに要るライブラリ
  headlessLinuxLibs =
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
      libelf
      libev
    ];

  # GUI アプリ (Tauri など) のビルドや実行に要るライブラリ
  guiLinuxLibs =
    pkgs: with pkgs; [
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
      libinput
      udev
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
      pangomm_2_48
      glib
      webkitgtk_4_1
      wayland
      dbus
      # pip で入れた Qt (PyQt5 など) の platform plugin が読み込む
      fontconfig
      freetype
      libxcb-wm
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
    ];

  darwinHome =
    { pkgs, ... }:
    {
      library.libs = with pkgs; [
        libiconv
        llvm
        nsis
      ];
      home.sessionVariablesExtra = ''
        export SDKROOT="$(xcrun --show-sdk-path)"
      '';
    };
in
{
  flake.modules.homeManager.base =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (config.library) libs;
    in
    {
      options.library.libs = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Libraries installed and exposed to compilers and the dynamic linker in interactive shells.";
      };

      config = {
        library.libs = with pkgs; [
          imagemagick
          ffmpeg
          curl
          openssl
          libssh
          sqlite
          icu
          pkg-config
        ];

        home.packages = libs;
        shell.interactiveVariables = rec {
          # 存在しないディレクトリは pkg-config が無視する。評価中に pathExists で
          # 確かめると各ライブラリの dev 出力のビルドが必要になる (IFD)。
          # zlib のように .pc を share/pkgconfig に置くものもあるので、両方を並べる。
          PKG_CONFIG_PATH = lib.concatStringsSep ":" [
            (lib.makeSearchPathOutput "dev" "lib/pkgconfig" libs)
            (lib.makeSearchPathOutput "dev" "share/pkgconfig" libs)
          ];
          LD_LIBRARY_PATH = lib.makeLibraryPath libs;
          LIBRARY_PATH = LD_LIBRARY_PATH;
        };
      };
    };

  # nix-ld と対話シェルの LD_LIBRARY_PATH には、層ごとに同じライブラリを入れる
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = headlessLinuxLibs pkgs;
      };
      people.home.library.libs = headlessLinuxLibs pkgs;
    };

  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      programs.nix-ld.libraries = guiLinuxLibs pkgs;
      people.home.library.libs = guiLinuxLibs pkgs;
    };

  flake.modules.darwin.base.people.home.imports = [ darwinHome ];
}
