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

    mdbook
    mdbook-admonish
    mdbook-mermaid

    trunk

    sea-orm-cli

    just
    typos
  ];

  programs.zsh.shellAliases = {
    typos = "typos --config ~/.config/typos.toml";
  };
}
