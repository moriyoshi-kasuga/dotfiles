{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup

    cargo-msrv
    cargo-nextest
    cargo-udeps
    cargo-tauri
    cargo-release
    cargo-audit
    cargo-udeps
    cargo-outdated
    cargo-deny
    sea-orm-cli
    just
  ];
}
