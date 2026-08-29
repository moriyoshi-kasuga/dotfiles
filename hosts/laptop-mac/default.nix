{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
  home = inputs.self.modules.homeManager;
in
{
  flake.darwinConfigurations.laptop-mac = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      darwin."host.common"
      (
        { pkgs, ... }:
        {
          system.primaryUser = "mori";
          users.users.mori.home = "/Users/mori";
          users.users.mori.shell = pkgs.fish;

          home-manager.users.mori = {
            home.username = "mori";
            home.homeDirectory = "/Users/mori";
            imports = [
              home."profile.core"
              home."profile.gui-common"
              home."darwin.homebrew"
              home."lang.c"
              home."lang.node"
              home."lang.rust"
            ];
          };
        }
      )
    ];
  };
}
