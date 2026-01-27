{ pkgs, ... }:

{
  imports = [
    ./niri
  ];

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
    clang-tools
    clang
    gcc-unwrapped
  ];
}
