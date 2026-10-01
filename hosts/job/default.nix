{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
  home = inputs.self.modules.homeManager;
in
{
  flake.darwinConfigurations.job = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      darwin.pc
      {
        people.primaryUser = "mori";
        style.fonts.monospace = "maple";

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
