{ inputs, ... }:

let
  inherit (inputs.self.modules) nixos darwin homeManager;
in
{
  # 層の配線: base は全 host、pc は画面を持つ host。
  # OS 側の層を import すると、対応する home 側の層も primaryUser に入る。
  flake.modules.nixos.base.people.home.imports = [ homeManager.base ];
  flake.modules.darwin.base.people.home.imports = [ homeManager.base ];

  flake.modules.nixos.pc = {
    imports = [ nixos.base ];
    people.home.imports = [ homeManager.pc ];
  };
  flake.modules.darwin.pc = {
    imports = [ darwin.base ];
    people.home.imports = [ homeManager.pc ];
  };
}
