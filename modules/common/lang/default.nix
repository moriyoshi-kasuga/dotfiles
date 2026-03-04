{ mkEnableOption, ... }:

{
  options.modules.lang.enable = mkEnableOption "enable lang settings";

  imports = [
    ./c.nix
    ./fsharp.nix
    ./go.nix
    ./haskell.nix
    ./jvm.nix
    ./node.nix
    ./python.nix
    ./rust.nix
    ./zig.nix
    ./buf.nix
  ];
}
