{ config, inputs, ... }:

let
  darwin = config.flake.modules.darwin;
  home = config.flake.modules.homeManager;
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
