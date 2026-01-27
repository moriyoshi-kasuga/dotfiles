{ pkgs, lib, ... }:

{
  home.activation.warnCargoEnv = (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.cargo/env" ]; then
        echo "warning: $HOME/.cargo/env not found (rustup not initialized?)" >&2
        echo "         Run:  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path" >&2
      fi
    ''
  );
  programs.zsh.envExtra = ''
    source "$HOME/.cargo/env"
  '';
  programs.fish.shellInit = ''
    fish_add_path $HOME/.cargo/bin
  '';

  home.packages = with pkgs; [
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
    dioxus-cli
    wasm-bindgen-cli

    sea-orm-cli

    rustypaste-cli
    just
    typos
    bacon
    tokei
    uv
    cyme
  ];

  home.shellAliases = {
    typos = "typos --config ~/.config/typos.toml";
  };
}
