{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
  home = inputs.self.modules.homeManager;
in
{
  flake.nixosConfigurations.sv-main = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos.base
      nixos.basic
      nixos.i18n
      nixos.network
      nixos.tailscale
      nixos."shell.fish"
      nixos."shell.zsh"
      nixos."tool.docker"
      ../../hosts/sv-main/hardware-configuration.nix
      (
        { pkgs, ... }:
        {
          people.primaryUser = "sv-main";
          networking.hostName = "sv-main";
          users.users.sv-main.shell = pkgs.fish;

          home-manager.users.sv-main = {
            home.username = "sv-main";
            home.homeDirectory = "/home/sv-main";
            imports = [
              home.base
              home."editor.neovim"
              home."editor.vim"
              home."lang.c"
              home."shell.basic"
              home."shell.fish"
              home."shell.zsh"
              home."tool.basic"
              home."tool.docker"
              home."tool.git.basic"
              home."tool.git.delta"
              home."tool.git.lazygit"
              home."tool.tff"
              home."tool.tmux"
            ];
          };
        }
      )
    ];
  };
}
