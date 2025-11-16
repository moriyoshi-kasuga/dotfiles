{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "pbpaste" ''
      win32yank.exe -o --lf
    '')
    (writeShellScriptBin "pbcopy" ''
      win32yank.exe -i --crlf
    '')
    (writeShellScriptBin "open" ''
      xdg-open "$@"
    '')
    xdg-utils
    docker
    docker-compose
    zsh
    gcc
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
    # maybe downgrade, mesa use llvm21, but vulkan use llvm20
    mesa
    libdrm
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
