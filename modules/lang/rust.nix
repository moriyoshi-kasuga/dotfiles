{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup

    cargo-msrv
    cargo-nextest
    cargo-udeps
    cargo-tauri
    cargo-release
    just
  ];
}
