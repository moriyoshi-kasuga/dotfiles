{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "pbpaste" ''
      wl-paste --no-newline
    '')
    (writeShellScriptBin "pbcopy" ''
      wl-copy --trim-newline
    '')
    (writeShellScriptBin "open" ''
      xdg-open "$@"
    '')
    (writeShellScriptBin "wigo" ''
      RUSTFLAGS="-Clinker=clang -Clink-args=--ld-path=wild" cargo $@
    '')
    wild-unwrapped
    xdg-utils
    docker
    docker-compose
    zsh
    clang
    gcc-unwrapped
  ];

  pkgPackages = with pkgs; [
    llvmPackages_20.libllvm

    at-spi2-atk
    atkmm
    cairo
    glib
    gtk3
    cairo
    gdk-pixbuf
    pango
    harfbuzz
    libsoup_3
    pango
    webkitgtk_4_1
    gobject-introspection

    alsa-lib
    vulkan-loader
    vulkan-tools
    libudev-zero
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    libxkbcommon
    mesa
    libdrm
    wayland
    alsa-lib
    libudev-zero
  ];
  ldLibraryPathPackages = with pkgs; [
    llvmPackages_20.libllvm

    wayland
    alsa-lib
    vulkan-loader
    libudev-zero
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    libxkbcommon
    mesa
    libdrm
  ];
}
