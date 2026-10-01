{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
  home = inputs.self.modules.homeManager;
in
{
  flake.darwinConfigurations.laptop-mac = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      darwin."profile.base"
      {
        people.primaryUser = "mori";

        people.home.imports = [
          home."profile.core"
          home."profile.gui"
          home."lang.c"
          home."lang.node"
          home."lang.rust"
        ];
      }
    ];
  };
}
