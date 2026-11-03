_:

{
  flake.modules.homeManager."lang.rust" =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.cargo-tauri ];

      # macOS で Tauri のアプリをビルドするのに要る
      library.libs = lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs;
        [
          llvm
          nsis
        ]
      );
    };
}
