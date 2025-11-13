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
  ];
}
