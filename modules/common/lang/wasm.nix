_:

{
  flake.modules.homeManager."lang.wasm" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wasm-bindgen-cli_0_2_108
        wasm-pack
        worker-build
      ];
    };
}
