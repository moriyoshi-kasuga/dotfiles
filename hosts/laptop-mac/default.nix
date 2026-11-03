{ config, inputs, ... }:

let
  darwin = config.flake.modules.darwin;
  home = config.flake.modules.homeManager;
in
{
  flake.darwinConfigurations.laptop-mac = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.pc
      darwin.omniwm
      darwin.ios-dev
      {
        nixpkgs.hostPlatform = "aarch64-darwin";
        people.primaryUser = "mori";
        people.flakeHost = "laptop-mac";

        people.home.imports = [
          home."lang.bash"
          home."lang.c"
          home."lang.dockerfile"
          home."lang.github-actions"
          home."lang.just"
          home."lang.nix"
          home."lang.node"
          home."lang.rust"
          home."lang.toml"
          home."lang.typst"
          home."lang.web"
        ];
      }
    ];
  };
}
