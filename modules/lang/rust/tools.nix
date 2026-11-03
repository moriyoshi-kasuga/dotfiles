_:

{
  flake.modules.homeManager."lang.rust" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cargo-expand
        cargo-hack
        cargo-msrv
        cargo-nextest
        cargo-udeps
        cargo-machete
        cargo-release
        cargo-audit
        cargo-outdated
        cargo-deny
        cargo-show-asm
        cargo-make
        cargo-llvm-lines
        cargo-depgraph
      ];
    };
}
