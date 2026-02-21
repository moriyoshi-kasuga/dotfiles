{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "rust";
  module = {
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

      just
      bacon
      tokei
      uv
      cyme
    ];
  };
}
