{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
  home = inputs.self.modules.homeManager;
in
{
  flake.darwinConfigurations.laptop-mac = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      darwin.base
      darwin.aerospace
      darwin.dock
      darwin.finder
      darwin.homebrew
      darwin.tailscale
      darwin.font
      darwin."shell.fish"
      darwin."shell.zsh"
      darwin."terminal.wezterm"
      darwin."tool.docker"
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
            imports = [
              home.base
              home."darwin.homebrew"
              home."editor.neovim"
              home."editor.vim"
              home."lang.c"
              home."lang.node"
              home."lang.rust"
              home.library
              home."shell.basic"
              home."shell.fish"
              home."shell.zsh"
              home."terminal.wezterm"
              home."tool.basic"
              home."tool.claude-code.basic"
              home."tool.docker"
              home."tool.git.basic"
              home."tool.git.delta"
              home."tool.git.lazygit"
              home."tool.tff"
              home."tool.tmux"
              home.wallpaper
            ];
          };
        }
      )
    ];
  };
}
