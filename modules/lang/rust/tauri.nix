_:

{
  flake.modules.homeManager."lang.rust" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.cargo-tauri ];
    };

  # macOS で Tauri のアプリをビルドするのに要る
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      people.home.library.libs = with pkgs; [
        llvm
        nsis
      ];
    };
}
