{ inputs, ... }:

let
  home = inputs.self.modules.homeManager;
in
{
  flake.modules.homeManager."profile.lang-full" = {
    imports = [
      home."lang.buf"
      home."lang.c"
      home."lang.elm"
      home."lang.fsharp"
      home."lang.go"
      home."lang.haskell"
      home."lang.jvm"
      home."lang.lua"
      home."lang.node"
      home."lang.python"
      home."lang.rust"
      home."lang.wasm"
      home."lang.zig"
    ];
  };
}
