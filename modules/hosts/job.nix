{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
  home = inputs.self.modules.homeManager;
in
{
  flake.darwinConfigurations.job = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      darwin."host.common"
      (
        { pkgs, ... }:
        {
          system.primaryUser = "mori";
          nix.settings.trusted-users = [
            "root"
            "mori"
          ];
          users.users.mori.home = "/Users/mori";
          users.users.mori.shell = pkgs.fish;

          home-manager.users.mori = {
            home.username = "mori";
            home.homeDirectory = "/Users/mori";
            modules.terminal.wezterm.bigMonitor = true;
            imports = [
              home."profile.core"
              home."profile.lang-full"
              home."darwin.homebrew"
            ];
          };
        }
      )
    ];
  };
}
