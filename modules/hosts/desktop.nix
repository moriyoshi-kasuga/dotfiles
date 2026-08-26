{ inputs, ... }:

let
  nixos = inputs.self.modules.nixos;
  home = inputs.self.modules.homeManager;
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos.base
      nixos.basic
      nixos.i18n
      nixos.network
      nixos.tailscale
      nixos.font
      nixos.library
      nixos."shell.fish"
      nixos."shell.zsh"
      nixos."terminal.wezterm"
      nixos."tool.docker"
      nixos."gui.amd"
      nixos."gui.audio"
      nixos."gui.basic"
      nixos."gui.bluetooth"
      nixos."gui.brave"
      nixos."gui.game"
      nixos."gui.i18n"
      nixos."gui.niri"
      nixos."gui.qt"
      nixos."gui.sddm"
      nixos."gui.thunar"
      nixos."gui.zed"
      ../../hosts/desktop/hardware-configuration.nix
      (
        { pkgs, ... }:
        {
          people.primaryUser = "mori";
          networking.hostName = "Mori-NixOS";
          users.users.mori.shell = pkgs.fish;

          home-manager.users.mori = {
            home.username = "mori";
            home.homeDirectory = "/home/mori";
            imports = [
              home.base
              home."editor.neovim"
              home."editor.vim"
              home."gui.brave"
              home."gui.niri"
              home."gui.qt"
              home."gui.zathura"
              home."lang.buf"
              home."lang.c"
              home."lang.elm"
              home."lang.fsharp"
              home."lang.go"
              home."lang.haskell"
              home."lang.jvm"
              home."lang.lua"
              home."lang.node"
              home."lang.python"
              home."lang.rust"
              home."lang.wasm"
              home."lang.zig"
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
