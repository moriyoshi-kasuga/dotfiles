{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.wasm";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      wasm-bindgen-cli_0_2_108
      wasm-pack
      worker-build
    ];
  };
}
