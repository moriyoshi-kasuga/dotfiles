{ config, inputs, ... }:

let
  darwin = config.flake.modules.darwin;
  home = config.flake.modules.homeManager;
in
{
  flake.darwinConfigurations.job = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.pc
      darwin.omniwm
      darwin.ios-dev
      {
        nixpkgs.hostPlatform = "aarch64-darwin";
        people.primaryUser = "mori";
        people.flakeHost = "job";

        people.home = {
          terminal.wezterm.bigMonitor = true;
          imports = [
            home."lang.rust"
            home."lang.wasm"
            home."lang.node"
            home."lang.lua"
            home."lang.python"
            home."lang.c"
            home."lang.bash"
            home."lang.dockerfile"
            home."lang.github-actions"
            home."lang.just"
            home."lang.nix"
            home."lang.toml"
            home."lang.typst"
            home."lang.web"
          ];
        };
      }
    ];
  };
}
