{ config, inputs, ... }:

let
  darwin = config.flake.modules.darwin;
  home = config.flake.modules.homeManager;
in
{
  flake.darwinConfigurations.laptop-mac = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.pc
      darwin.aerospace
      darwin.ios-dev
      {
        nixpkgs.hostPlatform = "aarch64-darwin";
        people.primaryUser = "mori";
        people.flakeHost = "laptop-mac";

        people.home.imports = [
          home."lang.c"
          home."lang.node"
          home."lang.rust"
        ];
      }
    ];
  };
}
