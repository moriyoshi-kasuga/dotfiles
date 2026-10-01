{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
  home = inputs.self.modules.homeManager;
in
{
  flake.darwinConfigurations.laptop-mac = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      darwin.pc
      {
        people.primaryUser = "mori";

        people.home.imports = [
          home."lang.c"
          home."lang.node"
          home."lang.rust"
        ];
      }
    ];
  };
}
