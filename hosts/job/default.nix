{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
  home = inputs.self.modules.homeManager;
in
{
  flake.darwinConfigurations.job = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      darwin."profile.base"
      {
        people.primaryUser = "mori";

        people.home = {
          modules.terminal.wezterm.bigMonitor = true;
          modules.font.monospace = "maple";
          imports = [
            home."profile.core"
            home."profile.gui"
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
