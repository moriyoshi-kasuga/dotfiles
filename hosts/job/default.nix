{ config, inputs, ... }:

let
  darwin = config.flake.modules.darwin;
  home = config.flake.modules.homeManager;
in
{
  flake.darwinConfigurations.job = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.pc
      darwin.ios-dev
      {
        nixpkgs.hostPlatform = "aarch64-darwin";
        people.primaryUser = "mori";

        people.home = {
          terminal.wezterm.bigMonitor = true;
          imports = [
            home."lang.rust"
            home."lang.wasm"
            home."lang.node"
            home."lang.lua"
            home."lang.python"
            home."lang.c"
          ];
        };
      }
    ];
  };
}
