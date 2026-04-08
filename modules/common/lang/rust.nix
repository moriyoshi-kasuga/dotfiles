{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.rust";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      cargo-msrv
      cargo-nextest
      cargo-udeps
      cargo-tauri
      cargo-release
      cargo-audit
      cargo-outdated
      cargo-deny
      cargo-show-asm
      cargo-make

      wasm-bindgen-cli_0_2_108
      wasm-pack
      worker-build

      tokei
      uv
      cyme
      hyperfine
      oha
    ];
  };
}
